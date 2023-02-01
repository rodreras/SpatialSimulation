/**
* Name: camposfloodingmodel
* This model is the final project of Spatial Simulation subject, taken in the Copernicus Master in Digital Earth. 

The main idea is to create a flooding model to the city of Campos dos Goytacazes, Rio de Janeiro, Brazil. According to the amount of rain, stream level might increase or not. As a consequence, cells/regions of the city to be flooded will be known. 
* Author: Rodrigo Brust Santos
* Tags: 
*/

/** Overview comments
 * 
 * Use a 30m resolution DEM
 *That will be about 500 cells. If there are any computational problems, try resampling it.
 * 
 * Also, you need to define what is a extreme hydrological event (check AlertaRio classification system)
 * 
 * Tente rebaixar o nível do Rio em -2m pois provavelmente o DEM pega a altitude da superficie.
 */



model camposfloodingmodel

global {
	/** Insert the global definitions, variables and actions here */
	file dem_file <- file('../includes/DEMProcessing/dem_90m_resample_10m_sub_merged.tif');
	file river_file <- file('../includes/river_shp/river.shp');
	file city_file <- file('../includes/roads_shp/roads.geojson');
	
	//Shape of the environment using the dem file
  	 geometry shape <- envelope(dem_file);
	
	// cell lists	
	list<cell> drain_cells;
	list<cell> source_cells;
	

	//variables
	float diffusion_rate <- 0.8;
	float input_water;
	
	init {
		//creating river
		create river from: river_file;
		//creating roads
		create roads from: city_file;
		
		//starting cells
		do init_cells;
		do init_water;
		
		//starting drain cells
		drain_cells <- cell where (each.is_drain);
		source_cells <- cell where (each.is_source);
		
		ask cell {
			do update_color;
		} 
		
	}
		
	 //Action to initialize the altitude value of the cell 
	 //according to the dem file
	action init_cells {
      ask cell {
         altitude <- grid_value;
         neighbor_cells <- (self neighbors_at 1) ;
		}
	}
	
	action init_water{
		int i <- 0;
		loop i from:0 to:5{
			ask cell[0,37+i]{
				water_height <- 6.8; // 6.8m is the avg height for the river in the CAMPOS - PONTE MUNICIPAL fluviometric station from 1922 to 2019.
				// 5,69m is the mean - 1std 
				// 7,88 is the mean + 1std
				is_source <- grid_x = 0;
				is_drain <- grid_y = matrix(cell).columns - 1 ;	
			}	
		}	
	}
	
	//Creating reflexes to add water in the water cells
	reflex add_water_input{
		float water_input <- input_water;
		ask source_cells {
			water_height <- water_height + water_input;
		}
	}
	
	//reflex to add water among the water cells
	reflex adding_input_water{
		float water_input <- input_water;
		ask source_cells {
			water_height <- water_height + water_input;
		}
	}
	
	//reflex to make water flow according to the altitude and obstacle
	reflex flowing{
		ask cell{already <- false;}
		ask (cell sort_by ((each.altitude + each.water_height))) {
			do flow;
		}
	}
	
	//update cell color
	reflex update_cell_color{
		ask cell{
			do update_color;
		}
	}
	
	reflex flooded{
		ask cell{
			float is_flooded <- 0.0;
		}
	}
			
	//draining cells
	reflex draining when: false {
		ask drain_cells{
			water_height <- 0.0;
		}
	}
	
}

grid cell file: dem_file neighbors: 8 frequency: 0  use_regular_agents: false use_individual_shapes: false use_neighbors_cache: false {
	float altitude;
	float water_height;
	float height;
	list<cell> neighbor_cells;
	bool is_drain;
	bool is_source;
	bool already;
	int is_flooded <- 0;	
	
	//create a function to flow the water
	action flow {
      	//if the height of the water is higher than 0 then, it can flow among the neighbour cells
         if (water_height > 0) {
         	//We get all the cells already done
            list<cell> neighbor_cells_al <- neighbor_cells where (each.already);
            //If there are cells already done then we continue
            if (!empty(neighbor_cells_al)) {
               //We compute the height of the neighbours cells according to their altitude, water_height and obstacle_height
               ask neighbor_cells_al {height <- altitude + water_height ;}
               //The height of the cell is equals to its altitude and water height
               height <-  altitude +  water_height;
               //The water of the cells will flow to the neighbour cells which have a height less than the height of the actual cell
               list<cell> flow_cells <- (neighbor_cells_al where (height > each.height)) ;
               //If there are cells, we compute the water flowing
               if (!empty(flow_cells)) {
                  loop flow_cell over: shuffle(flow_cells) sort_by (each.height){
                     float water_flowing <- max([0.0, min([(height - flow_cell.height), water_height * diffusion_rate])]); 
                     water_height <- water_height - water_flowing;
                     flow_cell.water_height <-flow_cell.water_height +  water_flowing;
                     height <- altitude + water_height;
                     is_flooded <- 1;                 
                  }   
               }
            }
         }
         already <- true;
      }  
      //Update the color of the cell
      action update_color { 
         int val_water <- 0;
         val_water <- max([0, min([255, int(255 * (1 - (water_height / 12.0)))])]) ;  
         color <- rgb([val_water, val_water, 255]);
         grid_value <- water_height + altitude;
         
     }
}

// setting up species view
species river {
	aspect default {
			draw shape color: #blue;
		}
	}

species roads {
	aspect default{
		draw shape color: #red;
	}


}


experiment camposfloodingmodel type: gui {
	parameter "input water" var: input_water <- 1.0;
	parameter "diffusion rate" var: diffusion_rate <- 0.8;
	
	output {
		display campos_view {
			grid cell border: #black transparency: 0.1;
			species roads;
			species river;
			
		}
	
	}
	
	
	reflex saveFile when: cycle=1000 {
		ask cell{
			grid_value <- is_flooded;
		}
		save cell to: "../results/cell_flooded_mean_std_minus.tif" type: geotiff; 
	}
 
}

/**
* Name: NewModel
* Based on the internal test template. 
* Author: s1093367
* Tags: 
*/

model Task6

global {
	/** Insert the global definitions, variables and actions here */
	
	//loading file
	file vector_data <- geojson_file('../includes/pasture.geojson', 31258);
	
	// defining the geom
	geometry pasture_polygon;
	
		
	//defining bounding box
	geometry shape <- envelope(vector_data);
	
	//and also the cow's radius
	float action_radius <- 10 #meters; 
	
	//declaring list within subset of grass cells inside the pasture
	list<grass> pasture_cells;
	
	//creating a parameter for choosing the movement type
	float move_type <- 1.0;
	
	
	init{
		
		//creating a variable for the pasture polygon
		pasture_polygon <- geometry(vector_data);
		
		//defining the grass cells within the polygon
		pasture_cells <- grass inside(pasture_polygon);
		
		//creating cows
		create cows number: 5 {
			location <- any_location_in(pasture_polygon);
		}
		
	}
	
	//creating a reflex so grass can grow biomass
	reflex update_biomass {
		 ask pasture_cells{
			if biomass < 10.0{
				biomass <- biomass + 0.2;
				color <- rgb(0, biomass * 10, 0);
			}
		}
	}

}

//creating a new species with the ability to move
species cows skills:[moving]{
	
	//setting cow's action area
	geometry action_area;
	
	//velocity definition
	float cow_speed <- 20.0;
	
	//setting cow amplitude
	float cow_amplitude <- 60.0;
	
	// creating grass variable
	grass grazed_grass;
	
	//cow attribute
	float energy <- 10.0;
	
	//grass selection reflex
	reflex grass_selection{
		
		//variable for picking pasture cell within cow's action radius
		list edible_grassCells <- (pasture_cells at_distance(action_radius));
			
		if move_type != 4{
			grazed_grass <- one_of (edible_grassCells);
		}
		
		if move_type = 4 {
			ask grass {
				grass choose_cell{
					return (grazed_grass.edible_grassCells) with max_of (each.biomass);	 
				}
			}
		}
	
	}
		
	//reflex to move
	reflex cow_movement {
		
		if move_type = 1{
			do wander speed: cow_speed bounds: pasture_polygon;
		}
		if move_type = 2{
			do wander amplitude: cow_amplitude speed: cow_speed bounds: pasture_polygon;
		}
		if move_type = 3{
			if self != cows[0] {
				do goto target: cows[0] speed: cow_speed;
			}
			else{
				do wander amplitude: cow_amplitude speed: cow_speed bounds: pasture_polygon;
			}
		}
			
		if move_type = 4 {
			do goto target: grazed_grass speed: cow_speed;
		}
	}
	
		//function to update action area of the cows and see where it can go
		reflex update_action_area{
		action_area <- circle(cow_speed) intersection cone (heading-(cow_amplitude/2), heading+(cow_amplitude/2));
		}
		
		//graze grass reflex
		reflex graze {
		if grazed_grass != nil {
			ask grazed_grass{
				if biomass > 3 {
					biomass <- biomass- 3;
					myself.energy <- myself.energy + 3;
					color <- rgb([0, biomass * 15, 0]);
				}
			}
		}
	}
	
		
	aspect default {
		draw circle(5) color: #black;
	}
	
	aspect cows_cone {
		draw action_area color:#red;
	}
}

grid grass{
	float biomass <- 5.0;
}

experiment Task6 type: gui autorun: false {
	/** Alternatively or in addition, you can insert here tests definitions */
	parameter "movement_type" var: move_type;
 	output {
		
		display map{
			grid grass; 
			species cows aspect:default refresh: true;
			species cows aspect: cows_cone transparency:0.5;
				
		}
		
		display BiomassVolume background: #white {
			chart "Total Amount of Biomass Consumed" type: series {
				loop i from: 0 to: length(cows) - 1 { 
					data "Cow " + i value: cows[i].energy  color: rgb([ i*10, i * 15, 0]) ;
				}
			}
		}
		
}
}

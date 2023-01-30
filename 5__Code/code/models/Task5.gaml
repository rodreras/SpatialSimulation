/**
* Name: Task5
* Based on the internal skeleton template. 
* Author: s1093367
* Tags: 
*/

model Task5

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
	
	
	
	init {
		
		// creating a variable for the pasture polygon
		pasture_polygon <- geometry(vector_data);
		
		pasture_cells <- grass inside(pasture_polygon);
		
		//creating cows
		create cows number: 10{
			location <- any_location_in(pasture_polygon);
			
		}
	}
	
	reflex update_biomass {
		 ask pasture_cells{
			if biomass < 10.0{
				biomass <- biomass + 0.2;
				color <- rgb(0, biomass * 10, 0);
			}
		}
	}
		
}

species cows skills:[moving]{
	
	//setting the geometry
	geometry action_area;
	
	//defining cow velocity
	float cow_speed <- 20.0;
	
	// setting cow amplitude
	float cow_amplitude <- 60.0;
	
	// setting grass variable
	grass grazed_grass; 
	//creating a reflex to see them moving with an amplitude of 60 degrees and bounds of 
	//pasture polygon
	
	reflex move {
		do wander amplitude: cow_amplitude speed: cow_speed bounds: pasture_polygon;
		
	}
	
	// action area: to see where it can go;
	
	reflex update_action_area {
		action_area <- circle(cow_speed) intersection cone (heading-(cow_amplitude/2), heading+(cow_amplitude/2));
		
	}
	
	reflex graze {
		grazed_grass <- one_of (pasture_cells at_distance(action_radius));
		if grazed_grass != nil {
			ask grazed_grass{
				if biomass > 3 {
					biomass <- biomass - 3;
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

experiment Task5 type: gui {
	/** Insert here the definition of the input and output of the model */
	output {
		
		display map{
			grid grass; 
			species cows aspect:default refresh: true;
			species cows aspect: cows_cone transparency:0.5;
				
		}
	}
}

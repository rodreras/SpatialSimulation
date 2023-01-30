
/**
* Name: NewModel
* Based on the internal test template. 
* Author: s1093367
* Tags: 
*/

model Task7

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
	int move_type <- 1 min: 1 max:4;
	
	//parameters
	int number_of_cows <- 5 min:3 max:50;
	float min_separation <- 3.0 min: 0.1 max: 10.0;
	int max_separate_turn <- 5 min:0 max: 20;
	int max_cohere_turn <- 5 min:0 max:20;
	int max_align_turn <- 8 min:0 max:20;
	float vision <- 45.0 min: 0.0 max: 70.0; 
	
	init{
		
		//creating a variable for the pasture polygon
		pasture_polygon <- geometry(vector_data);
		
		//defining the grass cells within the polygon
		pasture_cells <- grass inside(pasture_polygon);
		
		//creating cows
		create cows number: number_of_cows {
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

//-----------------   COW SPECIES  -------------/
//creating a new species with the ability to move
species cows skills:[moving]{
	
	//setting cow's action area
	geometry action_area;
	geometry action_buffer;
	
	//velocity definition
	float cow_speed <- 20.0;
	
	//setting cow amplitude
	float cow_amplitude <- 60.0;
	
	// creating grass variable
	grass grazed_grass;
	
	//cow attribute
	float energy <- 10.0;
	
	// setting color
	rgb colour <- #black;
	
	// flocking variables
	list<cows> flockmates;
	cows nearest_neighbour;
	int avg_head;
	int avg_twds_mates;
	
	//update cows action buffer
	reflex action_buffer_update{
		action_buffer <- circle(cow_speed, self.location);	
	}
	
	//flocking movement
	reflex flock {
		//in case all flocking params are zero wander randomly
		if (max_separate_turn = 0 and max_cohere_turn = 0 and max_align_turn =  0 ){
			do wander amplitude: 120.0;
		}
		
		// otherwise compute the heading for the next timestep in accordance to my flockmates
			else {
				// search for flockmates
				do find_flockmates ;
				// turn my heading to flock, if there are other agents in vision 
				if (not empty (flockmates)) {
					do find_nearest_neighbour;
					if (distance_to (self, nearest_neighbour) < min_separation) {
						do separate;
					}
					else {
						do align;
						do cohere;
					}
					// move forward in the new direction
					do move;
				}
				// wander randomly, if there are no other agents in vision
				else {
					do wander amplitude: 120.0;
				}
			}			
	}
	
	//flockmates are defined spatially, within a buffer of vision
		action find_flockmates {
	        flockmates <- ((cows overlapping (circle(vision))) - self);
		}
		
		//find nearest neighbour
		action find_nearest_neighbour {
	        nearest_neighbour <- flockmates with_min_of(distance_to (self.location, each.location)); 
		}		
		
	    // separate from the nearest neighbour of flockmates
	    action separate  {
	    	do turn_away (nearest_neighbour towards self, max_separate_turn);
	    }
	
	    //Reflex to align the boid with the other boids in the range
	    action align  {
	    	avg_head <- avg_mate_heading () ;
	        do turn_towards (avg_head, max_align_turn);
	    }
	
	    //Reflex to apply the cohesion of the boids group in the range of the agent
	    action cohere  {
			avg_twds_mates <- avg_heading_towards_mates ();
			do turn_towards (avg_twds_mates, max_cohere_turn); 
	    }
	    
	    //compute the mean vector of headings of my flockmates
	    int avg_mate_heading {
    		list<cows> flockmates_insideShape <- flockmates where (each.destination != nil);
    		float x_component <- sum (flockmates_insideShape collect (each.destination.x - each.location.x));
    		float y_component <- sum (flockmates_insideShape collect (each.destination.y - each.location.y));
    		//if the flockmates vector is null, return my own, current heading
    		if (x_component = 0 and y_component = 0) {
    			return heading;
    		}
    		//else compute average heading of vector  		
    		else {
    			// note: 0-heading direction in GAMA is east instead of north! -> thus +90
    			return int(-1 * atan2 (x_component, y_component) + 90);
    		}	
	    }  

	    //compute the mean direction from me towards flockmates	    
	    int avg_heading_towards_mates {
	    	float x_component <- mean (flockmates collect (cos (towards(self.location, each.location))));
	    	float y_component <- mean (flockmates collect (sin (towards(self.location, each.location))));
	    	//if the flockmates vector is null, return my own, current heading
	    	if (x_component = 0 and y_component = 0) {
	    		return heading;
	    	}
    		//else compute average direction towards flockmates
	    	else {
	    		// note: 0-heading direction in GAMA is east instead of north! -> thus +90
	    		return int(-1 * atan2 (x_component, y_component) + 90);	
	    	}
	    } 	    
	    
	    // cohere
	    action turn_towards (int new_heading, int max_turn) {
			int subtract_headings <- new_heading - heading;
			if (subtract_headings < -180) {subtract_headings <- subtract_headings + 360;}
			if (subtract_headings > 180) {subtract_headings <- subtract_headings - 360;}
	    	do turn_at_most ((subtract_headings), max_turn);
	    }

		// separate
	    action turn_away (int new_heading, int max_turn) {
			int subtract_headings <- heading - new_heading;
			if (subtract_headings < -180) {subtract_headings <- subtract_headings + 360;}
			if (subtract_headings > 180) {subtract_headings <- subtract_headings - 360;}
	    	do turn_at_most ((-1 * subtract_headings), max_turn);
	    }
	    
	    // align
	    action turn_at_most (int turn, int max_turn) {
	    	if abs (turn) > max_turn {
	    		if turn > 0 {
	    			//right turn
	    			heading <- heading + max_turn;
	    		}
	    		else {
	    			//left turn
	    			heading <- heading - max_turn;
	    		}
	    	}
	    	else {
	    		heading <- heading + turn;
	    	} 
	    }
		
		
		//definition of target grass cell
		reflex update_target_grass{
			list possible_target_grass <- pasture_cells inside(circle(cow_speed));
			grazed_grass <- (shuffle(possible_target_grass)) with_max_of each.biomass;
			
			if grazed_grass = nil {
				action_buffer <- circle(cow_speed);
				possible_target_grass <- pasture_cells overlapping (action_buffer);
				grazed_grass <- one_of(possible_target_grass);
			}
		}
		
		//cows moving to graze
		reflex cows_twrd_graze{
			do goto target: grazed_grass speed: 0.5 * cow_speed;
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
	
// VIZ SECTION
		
	aspect default {
		draw circle(5) color: #black;
	}
	
	aspect cows_cone {
		draw action_buffer color:#red;
	}
	
	aspect buffer{
		draw location + circle(vision) color: #grey;
	}
	
}

grid grass{
	float biomass <- 5.0;
}


//EXPERIEMNT SECTION 

experiment Task7 type: gui autorun: false {
	/** Alternatively or in addition, you can insert here tests definitions */
	
	//user defined parameters
	parameter 'iniatial number of animals' var: number_of_cows;
	parameter 'Max cohesion turn' var: max_cohere_turn ;
	parameter 'Max alignment turn' var:  max_align_turn; 
	parameter 'Max separation turn' var: max_separate_turn;
	parameter 'Minimal Distance'  var: min_separation;
	parameter 'Vision' var: vision;
 	output {
		
		display map{
			grid grass; 
			species cows aspect: cows_cone transparency:0.5;
			species cows aspect:default refresh: true;
			species cows aspect: buffer transparency: 0.4;				
		}
		

		}
		
	}


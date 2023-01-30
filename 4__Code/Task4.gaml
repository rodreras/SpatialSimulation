/**
* Name: Task4
* Based on the internal test template. 
* Author: rodri
* Tags: 
*/

model Task4

global {
	/** Insert the global definitions, variables and actions here */
	init {
		
		create cows number:5 {
			
		} // created 5 cows
		
		create sheeps number:3 {
			
		}  //created 3 sheeps
		
		create goats number:2 {
			
		}
	}	
}

species cows skills:[moving] {
	geometry action_area;
	float cowSpeed <- 3.0;
	float cowAmplitude <- 60.0;

	reflex move {
		do wander amplitude: cowAmplitude speed:cowSpeed;
		write "The cow's amplitude is " + cowAmplitude;
		write "This cow's speed is " + cowSpeed;
	}
	
	reflex update_action_area {
		action_area <- circle(cowSpeed) intersection cone (heading-(cowAmplitude/2), heading+(cowAmplitude/2));
		
	}
	
	aspect color_cows {
		draw circle(2) color: #blue;
	}
	
	aspect cows_cone {
		draw action_area color:#blue;
	}
}

species sheeps skills:[moving] {
	geometry action_area_sheep;
	float sheep_speed <- 1.0;
	
	reflex move{
		do move speed: sheep_speed;
	}
	
	reflex update_actionSheeps{
		action_area_sheep <- line(self.location, self.location+{0,-1}) intersection circle(sheep_speed);
	}
	
	aspect color_sheeps{
		draw circle(1) color: #black;
	}
	
	aspect sheeps_cone{
		draw action_area_sheep color: #grey;
	}
}

species goats skills:[moving] {
	geometry action_area_goat;
	float goat_speed <- 0.4;
	
	reflex move{
		do goto target: {0,0} speed:goat_speed;
	}
	
	reflex update_actionGoats{
		action_area_goat <- line(self.location, {0,0}) intersection circle(goat_speed);
	}
	
	aspect color_goats{
		draw circle(0.5) color: #red;
	}
	
	aspect goats_cone{
		draw action_area_goat color: #red;
	}
}

experiment Task4 type: gui {
	/** Insert here the definition of the input and output of the model */
	output {
		
		//print a map with the moving cows. (this is a display)
		display map{
			species cows aspect:color_cows;
			species cows aspect: cows_cone transparency:0.5;
			species sheeps aspect: color_sheeps;
			species sheeps aspect: sheeps_cone transparency: 0.5;
			species goats aspect: color_goats;
			species goats aspect: goats_cone transparency: 0.5;
		}
	}
}

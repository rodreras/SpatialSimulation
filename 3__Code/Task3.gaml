/**
* Name: Task3
* 3rd assingment of Spatial Simulation with application of new GAML concepts.
 
* Author: s1093367
* Tags: 
*/

model Task3

global {
	/** Insert the global definitions, variables and actions here */
	list<int> age_list <- [];
		
	init{
		// report that cows have been created
		//create 30 cows with age between 0 and 7
		create cows number: 30{
			age <- rnd(8);		
		}	
	}
	
	reflex report_age{
		
		age_list <- [];
		
		ask cows {
			age <-  age + 1;
			add age to: age_list;
		}
		write age_list;
		write 'average age is: ' + mean(age_list);
	}
}

species cows skills:[moving]{
	
	//here come de variables
	int age;
		
	//here comes the cow behaviour
	
	reflex mooing {
		//each time step is reports moo to the console
		//write "mooooooo!";
	}
	
	reflex move{
		if age > 4 {
			do wander;
			}
	}

		
	reflex dead{
		if age >= 15{
			write "I'm dying with age " + age;
			do die;
			create cows number: 1;
			age <- 1;
		}
	}
	
//	reflex born{
//		if age >= 14 {
//			create cows number: 1{
//			age <- 0;
//			write "Hello, world. New cow just arrived aging " + age;
//			}
//		}
//	}
		
	aspect default{
//		if age <= 4{
//		draw circle(2) color: #green;
//		}
//		else{
//		color <- rgb(age * 255/15, 0,0);
//		draw circle(2) color: color;}
		color <- rgb(255 - (mean(age_list) * 255/15), 0,0);
		draw circle(2) color: color;			
	}	
}

experiment Task3 type: gui {
	/** Insert here the definition of the input and output of the model */
	output {
		
		//print a map with the moving cows. (this is a display)
		display map{
			species cows aspect:default;
		}
	}
}

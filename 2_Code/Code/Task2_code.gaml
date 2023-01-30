/**
* Name: Task2
* This model is the second task of Spatial Simulation subject. 
* Author: s1093367
* Tags: 
*/

model Task2

global {
	//here come the global variables
	
	init{
		// report that cows have been created
		//create 30 cows with age between 0 and 7
		create cows number: 30{
			age <- rnd(8);	
			
		}
		
	}
}

species cows skills:[moving]{
	
	//here come de variables
	int age;
	
	//here comes the cow behaviour
	
	reflex mooing {
		//each time step is reports moo to the console
		write "mooooooo!";
	}
	
	reflex move{
		do wander;
	}
	
	reflex aging{
		age <-  age + 1;
	}
	
	reflex dead{
		write "Query, whether I need to die? " + age;
		if age >= 15{
			do die;
		}
	}
	
	reflex born{
		
		if age >= 14 {
			create cows number: 1{
			age <- 0;
			write "Hello, world. New cow just arrived";
			}
		
		}
		
	}
		
		
	aspect default{
		if age < 5 {
			draw circle(2) color: #orange;
			
		}
		else{
			draw circle(2) color: #red;
		}
	}
		
}
	
	//here we visualiye how the cows look like.

experiment Task2 type: gui {
	/** Insert here the definition of the input and output of the model */
	output {
		
		//print a map with the moving cows. (this is a display)
		display map{
			species cows aspect:default;
		}
	}
}

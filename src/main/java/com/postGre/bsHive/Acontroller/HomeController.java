package com.postGre.bsHive.Acontroller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	  
		@GetMapping(value = "/")
	    public String user_home() {
	        return "main";
	    }

}

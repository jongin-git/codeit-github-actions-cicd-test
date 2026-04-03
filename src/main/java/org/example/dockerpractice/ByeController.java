package org.example.dockerpractice;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ByeController {
    @GetMapping("/bye")
    public ResponseEntity bye() {
        return ResponseEntity.ok("Bye World");
    }
}

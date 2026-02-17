package com.Colonia.Administracion.Controller;

import com.Colonia.Administracion.Entity.Casa;
import com.Colonia.Administracion.Service.CasaService;
import jakarta.persistence.Column;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/api/Casa")
public class CasaController {
    private final CasaService casaService;

    public CasaController(CasaService casaService) {
        this.casaService = casaService;
    }

    @GetMapping
    public List<Casa> getAlllCasa(){ return casaService.getAllCasa(); }

    @PostMapping
    public ResponseEntity<Object> createCasa(@RequestBody Casa casa){
        try {
            Casa createCasa = casaService.saveCasa(casa);
            return new ResponseEntity<>(createCasa, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping
    public ResponseEntity<Object> deleteCasa(@PathVariable Integer id){
        try {
            if(casaService.getCasaById(id) == null) {
                return ResponseEntity.status(404).body("No exsite esta Casa");
            }
            casaService.deleteCasa(id);
            return ResponseEntity.status(202).build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al eliminar Casa");
        }
    }

    @PostMapping
    public ResponseEntity<Object> updateCasa(@PathVariable Integer id, @RequestBody Casa casa){
        try {
            Casa actualizado = casaService.updateCasa(id, casa);
            return ResponseEntity.ok(actualizado);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }

    }
}

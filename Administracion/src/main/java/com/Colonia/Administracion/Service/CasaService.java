package com.Colonia.Administracion.Service;

import com.Colonia.Administracion.Entity.Casa;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface CasaService {
    List<Casa> getAllCasa();
    Casa getCasaById(Integer id);
    Casa saveCasa(Casa casa) throws RuntimeException;
    Casa updateCasa(Integer id, Casa casa);
    void deleteCasa(Integer id);
}

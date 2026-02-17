package com.Colonia.Administracion.Service;

import com.Colonia.Administracion.Entity.Casa;
import com.Colonia.Administracion.Repository.CasaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CasaServiceImplements implements CasaService {
    private final CasaRepository casaRepository;

    public CasaServiceImplements(CasaRepository casaRepository) {
        this.casaRepository = casaRepository;
    }

    @Override
    public List<Casa> getAllCasa() { return casaRepository.findAll(); }

    @Override
    public Casa getCasaById(Integer id) { return casaRepository.getReferenceById(id); }

    @Override
    public Casa saveCasa(Casa casa) throws RuntimeException {
        try {
            if (casa == null
                || casa.getNoDeCasa() == null || casa.getNoDeCasa().isBlank()
                || casa.getEstado() == null
                || casa.getPropietario() == null || casa.getPropietario().isBlank()
                || casa.getPrecioCasa() <= 0){
                throw new IllegalArgumentException("Los campos deben de estar llenos y el precio debe ser mayor a 0");
            }
            if (casaRepository.existsByNoDeCasaAndEstadoAndPropietarioAndPreciocasa(
                    casa.getNoDeCasa(),
                    casa.getEstado(),
                    casa.getPropietario(),
                    casa.getPrecioCasa())){
                throw new RuntimeException("Ya existe una casa con estos datos");
            }

            return casaRepository.save(casa);
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Casa updateCasa(Integer id, Casa casa) {
        Casa existingCasa = casaRepository.findById(id).orElseThrow(() -> new RuntimeException("La casa no existe"));

            if (casa == null
            || casa.getNoDeCasa() == null || casa.getNoDeCasa().isBlank()
            || casa.getEstado() == null
            || casa.getPropietario() == null || casa.getPropietario().isBlank()
            || casa.getPrecioCasa() <= 0){
                throw new RuntimeException("Los campos deben de estar llenos y el precio debe ser mayor a 0");
            }

            if (casaRepository.existsByNoDeCasaAndEstadoAndPropietarioAndPreciocasa(
                    casa.getNoDeCasa(),
                    casa.getEstado(),
                    casa.getPropietario(),
                    casa.getPrecioCasa())){
                throw new RuntimeException("Ya existe una casa con estos datos");
            }

            return casaRepository.save(existingCasa);
    }

    @Override
    public void deleteCasa(Integer id) {
        if(!casaRepository.existsById(id)){
            throw new RuntimeException("Este id no existe");
        }
        casaRepository.deleteById(id);
    }
}

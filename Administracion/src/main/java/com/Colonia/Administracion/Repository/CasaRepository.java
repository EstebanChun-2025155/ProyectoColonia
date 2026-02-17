package com.Colonia.Administracion.Repository;

import com.Colonia.Administracion.Entity.Casa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CasaRepository extends JpaRepository<Casa, Integer>{
    Boolean existsByNoDeCasaAndEstadoAndPropietarioAndPreciocasa(
      String noDeCasa,
      Casa.estado estado,
      String propietario,
      Double precioCasa
    );
}

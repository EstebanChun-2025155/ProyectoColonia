package com.Colonia.Administracion.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "Casa")
public class Casa {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)

    @Column (name = "id_casa")
    private Integer idCasa;

    @Column (name = "no_de_casa")
    private String noDeCasa;

    @Column (name = "estado")
    private  estado estado;

    public enum estado {ocupado, disponible, mantenimiento}

    @Column (name = "propietario")
    private String propietario;

    @Column (name = "precio_casa")
    private double precioCasa;

    public Integer getIdCasa() {
        return idCasa;
    }

    public void setIdCasa(Integer idCasa) {
        this.idCasa = idCasa;
    }

    public String getNoDeCasa() {
        return noDeCasa;
    }

    public void setNoDeCasa(String noDeCasa) {
        this.noDeCasa = noDeCasa;
    }

    public estado getEstado() {
        return estado;
    }

    public void setEstado(estado estado) {
        this.estado = estado;
    }

    public String getPropietario() {
        return propietario;
    }

    public void setPropietario(String propietario) {
        this.propietario = propietario;
    }

    public double getPrecioCasa() {
        return precioCasa;
    }

    public void setPrecioCasa(double precioCasa) {
        this.precioCasa = precioCasa;
    }
}

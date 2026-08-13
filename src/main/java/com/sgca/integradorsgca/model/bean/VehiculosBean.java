package com.sgca.integradorsgca.model.bean;

import com.sgca.integradorsgca.model.bean.MarcaBean;
import com.sgca.integradorsgca.model.bean.ModelosBean;

import java.math.BigDecimal;
import java.util.Date;

public class VehiculosBean {
    private int id_Vehiculo;
    private int id_Modelo;
    private int id_Tipo;
    private int id_Agente;
    private String placa;
    private String color;
    private int anio;
    private BigDecimal precio;
    private int disponible;
    private Date fecha_registro;
    private String foto_Portada;
    private String descripcion;

    // Objetos anidados para acceder a las relaciones
    private MarcaBean marca;
    private ModelosBean modelos;
    private TiposVehiculoBean tipoVehiculo;

    public VehiculosBean(){}

    // Constructor para Inserción
    public VehiculosBean(int idModelo, int idTipo, int idAgente, String placa,
                         String color, int anio, BigDecimal precio,
                         int disponible, String fotoPortada) {
        this.id_Modelo = idModelo;
        this.id_Tipo = idTipo;
        this.id_Agente = idAgente;
        this.placa = placa;
        this.color = color;
        this.anio = anio;
        this.precio = precio;
        this.disponible = disponible;
        this.foto_Portada = fotoPortada;
    }

    // Constructor para Actualización
    public VehiculosBean(int idVehiculo, int idModelo, int idTipo, int idAgente,
                         String placa, String color, int anio, BigDecimal precio,
                         int disponible, String fotoPortada) {
        this.id_Vehiculo = idVehiculo;
        this.id_Modelo = idModelo;
        this.id_Tipo = idTipo;
        this.id_Agente = idAgente;
        this.placa = placa;
        this.color = color;
        this.anio = anio;
        this.precio = precio;
        this.disponible = disponible;
        this.foto_Portada = fotoPortada;
    }

    // --- GETTERS Y SETTERS EXISTENTES ---
    public int getId_Vehiculo() { return id_Vehiculo; }
    public void setId_Vehiculo(int id_Vehiculo) { this.id_Vehiculo = id_Vehiculo; }

    public int getId_Modelo() { return id_Modelo; }
    public void setId_Modelo(int id_Modelo) { this.id_Modelo = id_Modelo; }

    public int getId_Tipo() { return id_Tipo; }
    public void setId_Tipo(int id_Tipo) { this.id_Tipo = id_Tipo; }

    public int getId_Agente() { return id_Agente; }
    public void setId_Agente(int id_Agente) { this.id_Agente = id_Agente; }

    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public int getAnio() { return anio; }
    public void setAnio(int anio) { this.anio = anio; }

    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }

    public int getDisponible() { return disponible; }
    public void setDisponible(int disponible) { this.disponible = disponible; }

    public Date getFecha_registro() { return fecha_registro; }
    public void setFecha_registro(Date fecha_registro) { this.fecha_registro = fecha_registro; }

    public String getFoto_Portada() { return foto_Portada; }
    public void setFoto_Portada(String foto_Portada) { this.foto_Portada = foto_Portada; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public MarcaBean getMarca() { return marca; }
    public void setMarca(MarcaBean marca) { this.marca = marca; }

    public ModelosBean getModelos() { return modelos; }
    public void setModelos(ModelosBean modelos) { this.modelos = modelos; }

    public TiposVehiculoBean getTipoVehiculo() { return tipoVehiculo; }
    public void setTipoVehiculo(TiposVehiculoBean tipoVehiculo) { this.tipoVehiculo = tipoVehiculo; }
}
package com.sgca.integradorsgca.model.bean;

public class VehImgBean {
    private int idImagen;
    private int idVehiculo;
    private String rutaImagen;

    public VehImgBean() {
    }

    // Constructor para insertar imagenes
    public VehImgBean(int idVehiculo, String rutaImagen) {
        this.idVehiculo = idVehiculo;
        this.rutaImagen = rutaImagen;
    }

    // Constructor Completo
    public VehImgBean(int idImagen, int idVehiculo, String rutaImagen) {
        this.idImagen = idImagen;
        this.idVehiculo = idVehiculo;
        this.rutaImagen = rutaImagen;
    }

    public int getIdImagen() {
        return idImagen;
    }

    public void setIdImagen(int idImagen) {
        this.idImagen = idImagen;
    }

    public int getIdVehiculo() {
        return idVehiculo;
    }

    public void setIdVehiculo(int idVehiculo) {
        this.idVehiculo = idVehiculo;
    }

    public String getRutaImagen() {
        return rutaImagen;
    }

    public void setRutaImagen(String rutaImagen) {
        this.rutaImagen = rutaImagen;
    }
}
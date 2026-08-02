package com.sgca.integradorsgca.model.bean;


    public class TiposVehiculoBean {
        private int idTipo;
        private String nombre;

        public TiposVehiculoBean() {
        }

        public TiposVehiculoBean(int idTipo, String nombre) {
            this.idTipo = idTipo;
            this.nombre = nombre;
        }

        public TiposVehiculoBean(String nombre) {
            this.nombre = nombre;
        }

        public int getIdTipo() {
            return idTipo;
        }

        public void setIdTipo(int idTipo) {
            this.idTipo = idTipo;
        }

        public String getNombre() {
            return nombre;
        }

        public void setNombre(String nombre) {
            this.nombre = nombre;
        }
    }


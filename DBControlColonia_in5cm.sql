Drop database if exists DBControColonia_in5cm;
create database DBControColonia_in5cm;
use DBControColonia_in5cm;

create table Casa(
id_casa int auto_increment not null,
no_de_casa varchar(5) not null,
direccion varchar(60) not null,
estado enum("ocupada", "disponible", "mantenimiento") not null,
propietario varchar(100) not null,
precio_casa decimal(12,2) not null,
primary key PK_id_casa(id_casa)
);

create table Residente(
id_residente int not null auto_increment,
nombre_residente varchar(100),
dpi_residente varchar(20),
telefono_residente varchar(8),
posicion enum("activo", "inactivo") not null,
id_casa int not null,
primary key PK_id_residente(id_residente),
 constraint FK_residente_casa foreign key (id_casa)
references Casa(id_casa) on delete cascade
);

create table Visita(
id_visita int not null auto_increment,
nombre_visita varchar(100),
documento varchar(20),
placa varchar(8),
motivo varchar(50),
id_casa int not null,
primary key Pk_id_visita(id_visita),
	constraint Fk_residente_casa foreign key (id_casa)
references Casa(id_casa) on delete cascade
);

create table Accesos(
id_acceso int auto_increment,
tipo_persona enum("vista", "residente", "personal"),
id_persona int auto_increment,
hora_entrada date,
hora_salida date,
primary key Pk_id_visita(id_acceso)
);

create table Seguridad(
    id_seguridad int auto_increment not null,
    nombre varchar(100) not null,
    puesto varchar(50) not null,
    jornada enum('día', 'noche') not null,
    salario decimal(10,2) not null,
    telefono varchar(8) not null,
    primary key PK_id_seguridad(id_seguridad)
);

create table Limpieza(
    id_limpieza int auto_increment not null,
    nombre varchar(100) not null,
    puesto varchar(50) not null, -- (limpieza, jardinero, etc.)
    jornada enum('mañana', 'tarde', 'mixta') not null,
    salario decimal(10,2) not null,
    telefono varchar(8) not null,
    primary key PK_id_limpieza(id_limpieza)
);

-- PROCEDIMIENTO ALMACENADOS --

	-- Casa --
-- Create --
Delimiter $$ 
	create procedure sp_Casa_create(c_no_de_casa varchar(5), c_direccion varchar(60), 
    c_estado enum("ocupada", "disponible", "mantenimiento"), c_propietario varchar(100), c_precio_casa decimal(12, 2))
    begin 
		insert into Proveedores(no_de_casa, direccion, estado, propietario, precio_casa)
		values (c_no_de_casa, c_direccion, c_estado, c_propietario, c_precio_casa);
		select last_insert_id() as id_casa;
    end $$
Delimiter ;

-- Delete --
Delimiter $$
	create procedure sp_Casa_delete(in c_id_casa int )
    begin
		delete from Casa where id_casa = p_id_casa;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Read -- 
Delimiter $$
	create procedure sp_Casa_read_all()
    begin 
		select * from Casa order by id_casa;
    end $$
Delimiter ;

-- Update -- 
Delimiter $$
	create procedure sp_Casa_update(in c_id_casa int, in c_no_de_casa varchar(5), in c_direccion varchar(60), in c_estado enum("ocupada", "disponible", "mantenimiento"), 
    in c_propietario varchar(100), in c_precio_casa decimal(12, 2))
    begin 
		update Proveedores 
		set id_casa = c_id_casa,
			no_de_casa = c_no_de_casa,
            direccion = c_direccion,
            estado = c_estado,
            propietario = c_propietario,
            precio_casa = c_precio_casa
            where id_casa = c_id_casa;
		select row_count() as filas_afectadas;
    end $$
Delimiter ;

	-- Residente --
-- Create --
Delimiter $$
	create procedure sp_Residente_create(p_nombre_residente varchar(100), p_dpi_residente varchar(20),
    p_telefono_residente varchar(8), p_posicion enum("activo","inactivo"), p_id_casa int)
    begin
		insert into residente(nombre_residente, dpi_residente, telefono_residente, posicion, id_casa)
		values (p_nombre_residente, p_dpi_residente, p_telefono_residente, p_posicion, p_id_casa);
		select last_insert_id() as id_residente;
    end $$
Delimiter ;

-- Delete --
Delimiter $$
	create procedure sp_Residente_delete(in p_id_residente int )
    begin
		delete from residente where id_residente = p_id_residente;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Read -- 
Delimiter $$
	create procedure sp_Residente_read_all()
    begin
		select * from residente order by id_residente;
    end $$
Delimiter ;

-- Update -- 
Delimiter $$
	create procedure sp_Residente_update(in p_id_residente int, in p_nombre_residente varchar(100), in p_dpi_residente varchar(20),
    in p_telefono_residente varchar(8), in p_posicion enum("activo","inactivo"), in p_id_casa int)
    begin
		update residente
		set id_residente = p_id_residente,
			nombre_residente = p_nombre_residente,
            dpi_residente = p_dpi_residente,
            telefono_residente = p_telefono_residente,
            posicion = p_posicion,
            id_casa = p_id_casa
            where id_residente = p_id_residente;
		select row_count() as filas_afectadas;
    end $$
Delimiter ;

		-- Visita --
-- create --
delimiter $$
create procedure sp_visita_create(
    in v_nombre_visita varchar(100), 
    in v_documento varchar(20), 
    in v_placa varchar(8), 
    in v_motivo varchar(50), 
    in v_id_casa int
)
begin 
    insert into visita(nombre_visita, documento, placa, motivo, id_casa)
    values (v_nombre_visita, v_documento, v_placa, v_motivo, v_id_casa);
    select last_insert_id() as id_visita;
end $$
delimiter ;

-- delete --
delimiter $$
create procedure sp_visita_delete(in v_id_visita int)
begin
    delete from visita where id_visita = v_id_visita;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- read all --
delimiter $$
create procedure sp_visita_read_all()
begin 
    select * from visita order by id_visita;
end $$
delimiter ;

-- read by id --
delimiter $$
create procedure sp_visita_read_by_id(in v_id_visita int)
begin 
    select * from visita where id_visita = v_id_visita;
end $$
delimiter ;

-- update --
delimiter $$
create procedure sp_visita_update(
    in v_id_visita int, 
    in v_nombre_visita varchar(100), 
    in v_documento varchar(20), 
    in v_placa varchar(8), 
    in v_motivo varchar(50), 
    in v_id_casa int
)
begin 
    update visita 
    set nombre_visita = v_nombre_visita,
        documento = v_documento,
        placa = v_placa,
        motivo = v_motivo,
        id_casa = v_id_casa
    where id_visita = v_id_visita;
    select row_count() as filas_afectadas;
end $$
delimiter ;
		-- Acceso --
-- create --
delimiter $$
create procedure sp_accesos_create(
    in a_tipo_persona enum("vista", "residente", "personal"), 
    in a_id_persona int, 
    in a_hora_entrada date, 
    in a_hora_salida date
)
begin 
    insert into accesos(tipo_persona, id_persona, hora_entrada, hora_salida)
    values (a_tipo_persona, a_id_persona, a_hora_entrada, a_hora_salida);
    select last_insert_id() as id_acceso;
end $$
delimiter ;

-- delete --
delimiter $$
create procedure sp_accesos_delete(in a_id_acceso int)
begin
    delete from accesos where id_acceso = a_id_acceso;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- read all --
delimiter $$
create procedure sp_accesos_read_all()
begin 
    select * from accesos order by id_acceso;
end $$
delimiter ;

-- read by id --
delimiter $$
create procedure sp_accesos_read_by_id(in a_id_acceso int)
begin 
    select * from accesos where id_acceso = a_id_acceso;
end $$
delimiter ;

-- update --
delimiter $$
create procedure sp_accesos_update(
    in a_id_acceso int, 
    in a_tipo_persona enum("vista", "residente", "personal"), 
    in a_id_persona int, 
    in a_hora_entrada date, 
    in a_hora_salida date
)
begin 
    update accesos 
    set tipo_persona = a_tipo_persona,
        id_persona = a_id_persona,
        hora_entrada = a_hora_entrada,
        hora_salida = a_hora_salida
    where id_acceso = a_id_acceso;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- Create --
Delimiter $$ 
    create procedure sp_Seguridad_create(
        in s_nombre varchar(100), 
        in s_puesto varchar(50), 
        in s_jornada enum('día', 'noche'), 
        in s_salario decimal(10, 2), 
        in s_telefono varchar(8)
    )
    begin 
        insert into Seguridad(nombre, puesto, jornada, salario, telefono)
        values (s_nombre, s_puesto, s_jornada, s_salario, s_telefono);
        select last_insert_id() as id_seguridad;
    end $$
Delimiter ;

-- delete --
Delimiter $$
    create procedure sp_Seguridad_delete(in s_id_seguridad int)
    begin
        delete from Seguridad where id_seguridad = s_id_seguridad;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- read all -- 
Delimiter $$
    create procedure sp_Seguridad_read_all()
    begin 
        select * from Seguridad order by id_seguridad;
    end $$
Delimiter ;

-- read by id --
Delimiter $$
    create procedure sp_Seguridad_read_by_id(in s_id_seguridad int)
    begin 
        select * from Seguridad where id_seguridad = s_id_seguridad;
    end $$
Delimiter ;

-- update -- 
Delimiter $$
    create procedure sp_Seguridad_update(
        in s_id_seguridad int, 
        in s_nombre varchar(100), 
        in s_puesto varchar(50), 
        in s_jornada enum('día', 'noche'), 
        in s_salario decimal(10, 2), 
        in s_telefono varchar(8)
    )
    begin 
        update Seguridad 
        set nombre = s_nombre,
            puesto = s_puesto,
            jornada = s_jornada,
            salario = s_salario,
            telefono = s_telefono
        where id_seguridad = s_id_seguridad;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- create --
Delimiter $$ 
    create procedure sp_Limpieza_create(
        in l_nombre varchar(100), 
        in l_puesto varchar(50), 
        in l_jornada enum('mañana', 'tarde', 'mixta'), 
        in l_salario decimal(10, 2), 
        in l_telefono varchar(8)
    )
    begin 
        insert into Limpieza(nombre, puesto, jornada, salario, telefono)
        values (l_nombre, l_puesto, l_jornada, l_salario, l_telefono);
        select last_insert_id() as id_limpieza;
    end $$
Delimiter ;

-- delete --
Delimiter $$
    create procedure sp_Limpieza_delete(in l_id_limpieza int)
    begin
        delete from Limpieza where id_limpieza = l_id_limpieza;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- read all -- 
Delimiter $$
    create procedure sp_Limpieza_read_all()
    begin 
        select * from Limpieza order by id_limpieza;
    end $$
Delimiter ;

-- read by id --
Delimiter $$
    create procedure sp_Limpieza_read_by_id(in l_id_limpieza int)
    begin 
        select * from Limpieza where id_limpieza = l_id_limpieza;
    end $$
Delimiter ;

-- update -- 
Delimiter $$
    create procedure sp_Limpieza_update(
        in l_id_limpieza int, 
        in l_nombre varchar(100), 
        in l_puesto varchar(50), 
        in l_jornada enum('mañana', 'tarde', 'mixta'), 
        in l_salario decimal(10, 2), 
        in l_telefono varchar(8)
    )
    begin 
        update Limpieza 
        set nombre = l_nombre,
            puesto = l_puesto,
            jornada = l_jornada,
            salario = l_salario,
            telefono = l_telefono
        where id_limpieza = l_id_limpieza;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;
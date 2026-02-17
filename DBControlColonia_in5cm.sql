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
nombre_residente varchar(100) not null,
dpi_residente varchar(20) not null,
telefono_residente varchar(8) not null,
posicion enum("activo", "inactivo") not null,
id_casa int not null,
primary key PK_id_residente(id_residente),
constraint FK_residente_casa foreign key (id_casa)
references Casa(id_casa) on delete cascade
);

create table Visita(
id_visita int not null auto_increment,
nombre_visita varchar(100) not null,
documento varchar(20) not null,
placa varchar(8) not null,
motivo varchar(50) not null,
id_casa int not null,
primary key Pk_id_visita(id_visita),
constraint Fk_visita_casa foreign key (id_casa)
references Casa(id_casa) on delete cascade
);

create table Seguridad(
    id_seguridad int auto_increment not null,
    nombre varchar(100) not null,
    puesto varchar(50) not null,
    jornada enum('dia', 'noche') not null,
    salario decimal(10,2) not null,
    telefono varchar(8) not null,
    primary key PK_id_seguridad(id_seguridad)
);

create table Accesos(
id_acceso int auto_increment not null,
tipo_persona enum("visita", "residente", "personal") not null,
id_seguridad int not null,
hora_entrada datetime not null,
hora_salida datetime null,
primary key Pk_id_acceso(id_acceso),
constraint FK_id_seguridad foreign key (id_seguridad)
references Seguridad(id_seguridad) on delete cascade
);

create table Limpieza(
    id_limpieza int auto_increment not null,
    nombre varchar(100) not null,
    puesto varchar(50) not null, -- (limpieza, jardinero, etc.)
    jornada enum('manana', 'tarde', 'mixta') not null,
    salario decimal(10,2) not null,
    telefono varchar(8) not null,
    primary key PK_id_limpieza(id_limpieza)
);

create table Vehiculos(
    id_vehiculo int auto_increment not null,
    placa varchar(8) not null unique,
    marca_modelo varchar(50) not null,
    color varchar(30) not null,
    propietario varchar(100) not null,
    id_casa int not null,
    primary key(id_vehiculo),
    constraint fk_vehiculo_casa foreign key(id_casa)
	references Casa(id_casa) on delete cascade
);

create table Amenidades(
    id_amenidad int auto_increment not null,
    nombre_amenidad varchar(100) not null,
    horario_uso varchar(50) not null,
    costo_uso decimal(10,2) not null,
    estado enum('disponible','ocupado','mantenimiento') not null,
    capacidad int not null,
    primary key(id_amenidad)
);

create table Multas (
	id_multa int auto_increment not null,
    monto decimal(10,2) not null,
    descripcion varchar(100) not null,
    fecha_emision date not null,
    estado enum('pendiente', 'pagado', 'anulada') not null,
    tipo_multa varchar(50) not null,
    primary key (id_multa)
);

create table Pagos (
	id_pago int auto_increment not null,
	clasificacion_pago enum('multa', 'mantenimiento', 'amenidad')  not null,
    monto decimal(10,2) not null,
    fecha_pago date not null,
    metodo enum('efectivo', 'transferencia', 'tarjeta') not null,
    referencia varchar(50) not null,
    primary key (id_pago)
);


-- PROCEDIMIENTO ALMACENADOS --

	-- Casa --
-- Create --
Delimiter $$ 
	create procedure sp_Casa_create(c_no_de_casa varchar(5), c_direccion varchar(60), 
    c_estado enum("ocupada", "disponible", "mantenimiento"), c_propietario varchar(100), c_precio_casa decimal(12, 2))
    begin 
		insert into Casa(no_de_casa, direccion, estado, propietario, precio_casa)
		values (c_no_de_casa, c_direccion, c_estado, c_propietario, c_precio_casa);
		select last_insert_id() as id_casa;
    end $$
Delimiter ;

-- Delete --
Delimiter $$
	create procedure sp_Casa_delete(in c_id_casa int )
    begin
		delete from Casa where id_casa = c_id_casa;
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
		update Casa
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
    in a_tipo_persona enum("visita", "residente", "personal"), 
    in a_id_seguridad int, 
    in a_hora_entrada datetime, 
    in a_hora_salida datetime
)
begin 
    insert into accesos(tipo_persona, id_seguridad, hora_entrada, hora_salida)
    values (a_tipo_persona, a_id_seguridad, a_hora_entrada, a_hora_salida);
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
    in a_tipo_persona enum("visita", "residente", "personal"), 
    in a_id_seguridad int, 
    in a_hora_entrada datetime, 
    in a_hora_salida datetime
)
begin 
    update accesos 
    set tipo_persona = a_tipo_persona,
        id_seguridad = a_id_seguridad,
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
        in s_jornada enum('dia', 'noche'), 
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
        in s_jornada enum('dia', 'noche'), 
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
        in l_jornada enum('manana', 'tarde', 'mixta'), 
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
        in l_jornada enum('manana', 'tarde', 'mixta'), 
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

-- Vehiculos--

-- Create --
delimiter $$
create procedure sp_vehiculos_create(
    in v_placa varchar(8),
    in v_marca_modelo varchar(50),
    in v_color varchar(30),
    in v_propietario varchar(100),
    in v_id_casa int
)
begin
    insert into vehiculos(placa, marca_modelo, color, propietario, id_casa)
    values (v_placa, v_marca_modelo, v_color, v_propietario, v_id_casa);

    select last_insert_id() as id_vehiculo;
end $$
delimiter ;

-- read all --
delimiter $$
create procedure sp_vehiculos_read_all()
begin
    select * from vehiculos order by id_vehiculo;
end $$
delimiter ;

-- read by id -- 
delimiter $$
create procedure sp_vehiculos_read_by_id(in v_id_vehiculo int)
begin
    select * from vehiculos where id_vehiculo = v_id_vehiculo;
end $$
delimiter ;

-- update --
delimiter $$
create procedure sp_vehiculos_update(
    in v_id_vehiculo int,
    in v_placa varchar(8),
    in v_marca_modelo varchar(50),
    in v_color varchar(30),
    in v_propietario varchar(100),
    in v_id_casa int
)
begin
    update vehiculos
    set placa = v_placa,
        marca_modelo = v_marca_modelo,
        color = v_color,
        propietario = v_propietario,
        id_casa = v_id_casa
    where id_vehiculo = v_id_vehiculo;

    select row_count() as filas_afectadas;
end $$
delimiter ;

-- delete -- 
delimiter $$
create procedure sp_vehiculos_delete(in v_id_vehiculo int)
begin
    delete from vehiculos where id_vehiculo = v_id_vehiculo;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- Amenidades --

-- create --
delimiter $$
create procedure sp_amenidades_create(
    in a_nombre_amenidad varchar(100),
    in a_horario_uso varchar(50),
    in a_costo_uso decimal(10,2),
    in a_estado enum('disponible','ocupado','mantenimiento'),
    in a_capacidad int
)
begin
    insert into amenidades(nombre_amenidad, horario_uso, costo_uso, estado, capacidad)
    values (a_nombre_amenidad, a_horario_uso, a_costo_uso, a_estado, a_capacidad);

    select last_insert_id() as id_amenidad;
end $$
delimiter ;

-- read all-- 
delimiter $$
create procedure sp_amenidades_read_all()
begin
    select * from amenidades order by id_amenidad;
end $$
delimiter ;

-- read by id --
delimiter $$
create procedure sp_amenidades_read_by_id(in a_id_amenidad int)
begin
    select * from amenidades where id_amenidad = a_id_amenidad;
end $$
delimiter ;

-- update --
delimiter $$
create procedure sp_amenidades_update(
    in a_id_amenidad int,
    in a_nombre_amenidad varchar(100),
    in a_horario_uso varchar(50),
    in a_costo_uso decimal(10,2),
    in a_estado enum('disponible','ocupado','mantenimiento'),
    in a_capacidad int
)
begin
    update amenidades
    set nombre_amenidad = a_nombre_amenidad,
        horario_uso = a_horario_uso,
        costo_uso = a_costo_uso,
        estado = a_estado,
        capacidad = a_capacidad
    where id_amenidad = a_id_amenidad;

    select row_count() as filas_afectadas;
end $$
delimiter ;

-- delete --
delimiter $$
create procedure sp_amenidades_delete(in a_id_amenidad int)
begin
    delete from amenidades where id_amenidad = a_id_amenidad;
    select row_count() as filas_afectadas;
end $$
delimiter ;

	-- Multas --
-- create --
delimiter $$ 
create procedure sp_Multas_create(
    in m_monto decimal(10,2), 
    in m_descripcion varchar(100), 
    in m_fecha_emision date, 
    in m_estado enum('pendiente', 'pagado', 'anulada'), 
    in m_tipo_multa varchar(50)
)
begin 
    insert into Multas(monto, descripcion, fecha_emision, estado, tipo_multa)
    values (m_monto, m_descripcion, m_fecha_emision, m_estado, m_tipo_multa);
    select last_insert_id() as id_multa;
end $$
delimiter ;

-- Delete --
delimiter $$
create procedure sp_Multas_delete(in m_id_multa int)
begin
    delete from Multas where id_multa = m_id_multa;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- Read -- 
delimiter $$
create procedure sp_Multas_read_all()
begin 
    select * from Multas order by id_multa;
end $$
delimiter ;

-- Update -- 
delimiter $$
create procedure sp_Multas_update(
    in m_id_multa int,
    in m_monto decimal(10,2), 
    in m_descripcion varchar(100), 
    in m_fecha_emision date, 
    in m_estado enum('pendiente', 'pagado', 'anulada'), 
    in m_tipo_multa varchar(50)
)
begin 
    update Multas 
    set monto = m_monto,
        descripcion = m_descripcion,
        fecha_emision = m_fecha_emision,
        estado = m_estado,
        tipo_multa = m_tipo_multa
    where id_multa = m_id_multa;
    select row_count() as filas_afectadas;
end $$
delimiter ;

	-- Pagos --
-- Create --
delimiter $$ 
create procedure sp_Pagos_create(
    in p_clasificacion_pago enum('multa', 'mantenimiento', 'amenidad'), 
    in p_monto decimal(10,2), 
    in p_fecha_pago date, 
    in p_metodo enum('efectivo', 'transferencia', 'tarjeta'), 
    in p_referencia varchar(50)
)
begin 
    insert into Pagos(clasificacion_pago, monto, fecha_pago, metodo, referencia)
    values (p_clasificacion_pago, p_monto, p_fecha_pago, p_metodo, p_referencia);
    select last_insert_id() as id_pago;
end $$
delimiter ;

-- Delete --
delimiter $$
create procedure sp_Pagos_delete(in p_id_pago int)
begin
    delete from Pagos where id_pago = p_id_pago;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- Read -- 
delimiter $$
create procedure sp_Pagos_read_all()
begin 
    select * from Pagos;
end $$
delimiter ;

-- Update -- 
delimiter $$
create procedure sp_Pagos_update(
    in p_id_pago int,
    in p_clasificacion_pago enum('multa', 'mantenimiento', 'amenidad'), 
    in p_monto decimal(10,2), 
    in p_fecha_pago date, 
    in p_metodo enum('efectivo', 'transferencia', 'tarjeta'), 
    in p_referencia varchar(50)
)
begin 
    update Pagos 
    set clasificacion_pago = p_clasificacion_pago,
        monto = p_monto,
        fecha_pago = p_fecha_pago,
        metodo = p_metodo,
        referencia = p_referencia
    where id_pago = p_id_pago;
    select row_count() as filas_afectadas;
end $$
delimiter ;
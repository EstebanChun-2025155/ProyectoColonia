create database DBControColonia_in5cm;
use DBControColonia_in5cm;

create table Casa(
	id_Casa int auto_increment not null,
	no_De_Casa varchar(5) not null,
	direccion varchar(25) not null,
	estado enum("ocupada", "disponible", "mantenimiento") not null,
	propietario varchar(100) not null,
	precio_Casa decimal(12,2) not null,
	primary key PK_id_casa(id_Casa)
);

create table Seguridad (
    id_Seguridad int auto_increment not null,
    nombre varchar(100) not null,
    puesto varchar(100) not null,
    jornada enum('dia','noche') not null,
    salario decimal(10,2) not null,
    telefono varchar(20) not null,
    primary key PK_id_seguridad(id_Seguridad)
);

create table Limpieza (
    id_Limpieza int auto_increment not null,
    nombre varchar(100) not null,
    puesto varchar(100) not null,
    jornada enum('manana','tarde') not null,
    salario decimal(10,2) not null,
    telefono varchar(20) not null,
    primary key PK_id_Limpieza(id_Limpieza)
);

create table Amenidades(
    id_Amenidad int auto_increment not null,
    nombre_Amenidad varchar(100) not null,
    horario_Uso varchar(30) not null,
    costo_Uso decimal(12,2) not null,
    estado enum('disponible','ocupado','mantenimiento') not null,
    capacidad int not null,
    primary key Pk_id_Amenidad(id_Amenidad)
);

create table Multa (
	id_Multa int not null auto_increment,
    monto decimal(12,2) not null,
    descripcion varchar(100) not null,
    fecha_Emision date not null,
    estado enum('pendiente', 'pagado', 'anulada') not null,
    tipo_Persona enum("visita", "residente") not null,
    primary key PK_id_multa(id_Multa)
);

create table Vehiculos(
    id_Vehiculo int auto_increment not null,
    placa varchar(8) not null unique,
    marca_Modelo varchar(30) not null,
    color varchar(20) not null,
    propietario varchar(100) not null,
    id_Casa int not null,
    primary key Pk_id_Vehiculo(id_Vehiculo),
    constraint fk_Vehiculo_casa foreign key(id_Casa)
        references Casa(id_Casa) on delete cascade
);

create table Residente(
	id_Residente int not null auto_increment,
	nombre_Residente varchar(100) not null,
	dpi_Residente varchar(13) not null,
	telefono_Residente varchar(8) not null,
	Posicion enum("activo", "inactivo") not null,
	id_Casa int not null,
	primary key PK_id_Residente(id_Residente),
	constraint FK_Residente_Casa foreign key (id_Casa)
	references Casa(id_Casa) on delete cascade
);

create table Visita(
	id_Visita int auto_increment not null,
    nombre_Visita varchar(80) not null,
    documento varchar(20) not null, 
    placa varchar(10) not null,
    motivo varchar(150) not null,
    id_Casa int not null,
    primary key Pk_id_Visita (id_Visita),
    constraint FK_Visita_Casa foreign key (id_Casa)
	references Casa(id_Casa) on delete cascade
);

create table Accesos(
	id_Acceso int auto_increment not null,
	tipo_Persona enum("visita", "residente", "personal") not null,
	id_Seguridad int not null,
	hora_Entrada datetime not null,
	hora_Salida datetime null,
	primary key Pk_id_acceso(id_Acceso),
	constraint FK_id_seguridad foreign key (id_Seguridad)
	references Seguridad(id_Seguridad) on delete cascade
);

create table Pago (
	id_Pago int not null auto_increment,
    id_Residente int not null,
	clasificacion_Pago enum('multa', 'mantenimiento', 'amenidad')  not null,
    monto decimal(12,2) not null,
    fecha_Pago date not null,
    metodo enum('efectivo', 'transferencia', 'tarjeta') not null,
    referencia varchar(30) not null,
    primary key PK_id_Pago(id_Pago),
	constraint FK_id_residente foreign key (id_Residente)
    references Residente(id_Residente) on delete cascade
);

-- PROCEDIMIENTOS ALMACENADOS



-- Casa --
-- Create --
Delimiter $$ 
	create procedure sp_Casa_create(p_no_De_Casa varchar(5), p_direccion varchar(25), 
    p_estado enum("ocupada", "disponible", "mantenimiento"), p_propietario varchar(100), p_precio_Casa decimal(12, 2))
    begin 
		insert into Casa(no_De_Casa, direccion, estado, propietario, precio_Casa)
		values (p_no_De_Casa, p_direccion, p_estado, p_propietario, p_precio_Casa);
		select last_insert_id() as id_Casa;
    end $$
Delimiter ;

-- Delete --
Delimiter $$
	create procedure sp_Casa_delete(in p_id_Casa int )
    begin
		delete from Casa where id_Casa = p_id_Casa;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Read -- 
Delimiter $$
	create procedure sp_Casa_read_all()
    begin 
		select * from Casa order by id_Casa;
    end $$
Delimiter ;

-- Update -- 
Delimiter $$
	create procedure sp_Casa_update(in p_id_Casa int, in p_no_De_Casa varchar(5), in p_direccion varchar(25), in p_estado enum("ocupada", "disponible", "mantenimiento"), 
    in p_propietario varchar(100), in p_precio_Casa decimal(12, 2))
    begin 
		update Casa
		set no_De_Casa = p_no_De_Casa,
            direccion = p_direccion,
            estado = p_estado,
            propietario = p_propietario,
            precio_Casa = p_precio_Casa
            where id_Casa = p_id_Casa;
		select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Seguridad --
-- Create --
Delimiter $$ 
    create procedure sp_Seguridad_create(p_nombre varchar(100), p_puesto varchar(100), 
    p_jornada enum('dia','noche'), p_salario decimal(10, 2), p_telefono varchar(20))
    begin 
        insert into Seguridad(nombre, puesto, jornada, salario, telefono)
        values (p_nombre, p_puesto, p_jornada, p_salario, p_telefono);
        select last_insert_id() as id_Seguridad;
    end $$
Delimiter ;

-- Delete --
Delimiter $$
    create procedure sp_Seguridad_delete(in p_id_Seguridad int)
    begin
        delete from Seguridad where id_Seguridad = p_id_Seguridad;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Read -- 
Delimiter $$
    create procedure sp_Seguridad_read_all()
    begin 
        select * from Seguridad order by id_Seguridad;
    end $$
Delimiter ;

-- Update -- 
Delimiter $$
    create procedure sp_Seguridad_update(in p_id_Seguridad int, in p_nombre varchar(100), in p_puesto varchar(100), 
    in p_jornada enum('dia','noche'), in p_salario decimal(10, 2), in p_telefono varchar(20))
    begin 
        update Seguridad
        set nombre = p_nombre,
            puesto = p_puesto,
            jornada = p_jornada,
            salario = p_salario,
            telefono = p_telefono
            where id_Seguridad = p_id_Seguridad;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Limpieza --
-- Create --
Delimiter $$
    create procedure sp_Limpieza_create(p_nombre varchar(100), p_puesto varchar(100), 
    p_jornada enum('manana','tarde'), p_salario decimal(10, 2), p_telefono varchar(20))
    begin
        insert into Limpieza(nombre, puesto, jornada, salario, telefono)
        values (p_nombre, p_puesto, p_jornada, p_salario, p_telefono);
        select last_insert_id() as id_Limpieza;
    end $$
Delimiter ;

-- Delete --
Delimiter $$
    create procedure sp_Limpieza_delete(in p_id_limpieza int)
    begin
        delete from Limpieza where id_Limpieza = p_id_limpieza;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Read -- 
Delimiter $$
    create procedure sp_Limpieza_read_all()
    begin
        select * from Limpieza order by id_Limpieza;
    end $$
Delimiter ;

-- Update -- 
Delimiter $$
    create procedure sp_Limpieza_update(in p_id_Limpieza int, in p_nombre varchar(100), in p_puesto varchar(100), 
    in p_jornada enum('manana','tarde'), in p_salario decimal(10, 2), in p_telefono varchar(20))
    begin
        update Limpieza
        set nombre = p_nombre,
            puesto = p_puesto,
            jornada = p_jornada,
            salario = p_salario,
            telefono = p_telefono
            where id_Limpieza = p_id_Limpieza;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- AMENIDADES
-- Create
	Delimiter $$
	create procedure sp_amenidad_create(a_nombre_Amenidad varchar(100),a_horario_Uso varchar(30),
    a_costo_Uso decimal(12,2),a_estado enum('disponible','ocupado','mantenimiento'),a_capacidad int)
		begin
			insert into Amenidades(nombre_Amenidad, horario_Uso, costo_Uso, estado, capacidad)
			values(a_nombre_Amenidad, a_horario_Uso, a_costo_Uso, a_estado, a_capacidad);
			select last_insert_id() as id_amenidad;
		end $$
	Delimiter ;

-- Delete
	Delimiter $$
	create procedure sp_amenidad_delete(in a_id_amenidad int)
		begin
			delete from Amenidades where id_Amenidad = a_id_amenidad;
			select row_count() as filas_afectadas;
		end $$
	Delimiter ;

-- Read
	Delimiter $$
	create procedure sp_amenidad_read_all()
		begin
			select * from Amenidades order by id_Amenidad;
		end $$
	Delimiter ;

-- Update
	Delimiter $$
	create procedure sp_amenidad_update(in p_id_amenidad int, in p_nombre_Amenidad varchar(100),in p_horario_Uso varchar(30),
    in p_costo_Uso decimal(12,2), in p_estado enum('disponible','ocupado','mantenimiento'), in p_capacidad int)
		begin
			update Amenidades
			set nombre_Amenidad = p_nombre_Amenidad,
				horario_Uso = p_horario_Uso,
				costo_Uso = p_costo_Uso,
				estado = p_estado,
				capacidad = p_capacidad
			where id_Amenidad = p_id_amenidad;
		select row_count() as filas_afectadas;
		end $$
	Delimiter ;

-- MULTAS --
-- create --
delimiter $$
create procedure sp_Multa_create(
    in p_monto decimal(12,2),
    in p_descripcion varchar(100),
    in p_fecha_Emision date,
    in p_estado enum('pendiente', 'pagado', 'anulada'),
    in p_tipo_Persona enum('visita','residente')
)
begin
    insert into Multa (monto, descripcion, fecha_Emision, estado, tipo_Persona)
		values (p_monto, p_descripcion, p_fecha_Emision, p_estado, p_tipo_Persona);
    select last_insert_id() as id_Multa;
end $$
delimiter ;

-- Delete --
delimiter $$
create procedure sp_Multa_delete(in p_id_Multa int)
begin
    delete from Multa where id_Multa = p_id_Multa;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- Read --
delimiter $$
create procedure sp_Multa_read_all()
begin
    select * from Multa order by id_Multa;
end $$
delimiter ;

-- Update --
delimiter $$
create procedure sp_Multa_update(
    in p_id_Multa int,
    in p_monto decimal(12,2),
    in p_descripcion varchar(100),
    in p_fecha_Emision date,
    in p_estado enum('pendiente', 'pagado', 'anulada'),
    in p_tipo_Persona enum('visita','residente')
)
begin
    update Multa
    set monto = p_monto,
        descripcion = p_descripcion,
        fecha_Emision = p_fecha_Emision,
        estado = p_estado,
        tipo_Persona = p_tipo_Persona
    where id_Multa = p_id_Multa;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- Vehiculos
-- Create
	Delimiter $$
		create procedure sp_vehiculo_create(p_placa varchar(8), p_marca_Modelo varchar(30),
		p_color varchar(20), p_propietario varchar(100),p_id_casa int)
		begin
			insert into Vehiculos(placa, marca_Modelo, color, propietario, id_Casa)
			values (p_placa, p_marca_Modelo, p_color, p_propietario, p_id_casa);
		end $$
	Delimiter ;

-- Delete
	Delimiter $$
		create procedure sp_vehiculo_delete(in p_id_Vehiculo int)
		begin
			delete from Vehiculos where id_Vehiculo = p_id_Vehiculo;
			select row_count() as filas_afectadas;
		end $$
	Delimiter ;

-- Read
	Delimiter $$
		create procedure sp_vehiculo_read_all()
		begin
			select * from Vehiculos order by id_Vehiculo;
		end $$
	Delimiter ;

-- Update
	Delimiter $$
		create procedure sp_vehiculo_update(in p_id_Vehiculo int, in p_placa varchar(8),in p_marca_Modelo varchar(30),
        in p_color varchar(20), in p_propietario varchar(100),in p_id_Casa int)
		begin
			update Vehiculos
			set placa = p_placa,
				marca_Modelo = p_marca_Modelo,
				color = p_color,
				propietario = p_propietario,
				id_Casa = p_id_Casa
				where id_Vehiculo = p_id_Vehiculo;
			select row_count() as filas_afectadas;
		end $$
	Delimiter ;

-- Residente --
-- Create --
Delimiter $$
	create procedure sp_Residente_create(p_nombre_Residente varchar(100), p_dpi_Residente varchar(13),
    p_telefono_Residente varchar(8), p_Posicion enum("activo","inactivo"), p_id_Casa int)
    begin
		insert into Residente(nombre_Residente, dpi_Residente, telefono_Residente, Posicion, id_Casa)
		values (p_nombre_Residente, p_dpi_Residente, p_telefono_Residente, p_Posicion, p_id_Casa);
		select last_insert_id() as id_residente;
    end $$
Delimiter ;

-- Delete --
Delimiter $$
	create procedure sp_Residente_delete(in p_id_Residente int )
    begin
		delete from Residente where id_Residente = p_id_Residente;
        select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Read -- 
Delimiter $$
	create procedure sp_Residente_read_all()
    begin
		select * from Residente order by id_Residente;
    end $$
Delimiter ;

-- Update -- 
Delimiter $$
	create procedure sp_Residente_update(in p_id_Residente int, in p_nombre_Residente varchar(100), in p_dpi_Residente varchar(13),
    in p_telefono_Residente varchar(8), in p_Posicion enum("activo","inactivo"), in p_id_Casa int)
    begin
		update Residente
		set nombre_Residente = p_nombre_Residente,
            dpi_Residente = p_dpi_Residente,
            telefono_Residente = p_telefono_Residente,
            Posicion = p_Posicion,
            id_Casa = p_id_Casa
            where id_Residente = p_id_Residente;
		select row_count() as filas_afectadas;
    end $$
Delimiter ;

-- Visitas --
-- Create --
delimiter $$
create procedure sp_Visita_create(in p_Nombre varchar(80), in p_Documento varchar(20),
								   in p_Placa varchar(10),in p_Motivo varchar(150),
                                   in id_Casita int)
begin
	insert into Visita(nombre_Visita,
					   documento,
                       placa,
                       motivo,
                       id_Casa)
		values (p_Nombre,
				p_Documento,
				p_Placa,
				p_Motivo,
				id_Casita);

End $$
delimiter ;

-- Read --
delimiter $$
create procedure sp_Visitas_read_all()
		Begin 
        select id_Visita, nombre_Visita, documento, placa, motivo, id_Casa
        from Visita;
	End $$
delimiter ;

-- Delete --
delimiter $$
create procedure sp_Visitas_delete(in p_id int)
begin
		delete from Visita
        where id_Visita = p_id;
End $$
delimiter ; 

-- Update--
delimiter $$
create procedure  sp_Visitas_update(in p_id int, in p_Nombre varchar(80), in p_Documento varchar(20),
									  in p_Placa varchar(10),in p_Motivo varchar(150),
									  in id_casita int)
begin 
		update Visita
        set nombre_Visita = p_Nombre,
			 documento = p_Documento,
             placa = p_Placa,
             motivo = p_Motivo,
             id_Casa = id_casita
		where id_Visita = p_id;
End $$
delimiter ;

-- Accesos--
-- create--
delimiter $$
create procedure sp_Accesos_create(in p_tipo_Persona enum("visita", "residente", "personal"), in p_id_Seguridad int,
								   in p_hora_Entrada datetime,in p_hora_Salida datetime)
begin
	insert into Accesos(tipo_Persona,
					   id_Seguridad,
                       hora_Entrada,
                       hora_Salida)
		values (p_tipo_Persona,
				p_id_Seguridad,
				p_hora_Entrada,
				p_hora_Salida);
End $$
delimiter ;

-- Read--
delimiter $$
create procedure sp_Accesos_read_all()
		Begin 
        select id_Acceso, tipo_Persona, id_Seguridad, hora_Entrada, hora_Salida
        from Accesos;
	End $$
delimiter ;

-- Delete --
delimiter $$
create procedure sp_Accesos_delete(in p_id_Acceso int)
begin
		delete from Accesos 
        where id_Acceso = p_id_Acceso;
End $$
delimiter ; 

-- Update--
delimiter $$
create procedure  sp_Accesos_update(in p_id_Acceso int, in p_tipo_Persona enum("visita", "residente", "personal"), in p_id_Seguridad int,
								   in p_hora_Entrada datetime,in p_hora_Salida datetime)
begin 
		update Accesos
        set tipo_Persona = p_tipo_Persona,
			 id_Seguridad = p_id_Seguridad,
             hora_Entrada = p_hora_Entrada,
             hora_Salida = p_hora_Salida
             where id_Acceso = p_id_Acceso;
End $$
delimiter ;

-- PAGOS --
-- Create --
delimiter $$
create procedure sp_Pago_create(
	in p_id_Residente int,
    in p_clasificacion_Pago enum('multa', 'mantenimiento', 'amenidad'),
    in p_monto decimal(12,2),
    in p_fecha_Pago date,
    in p_metodo enum('efectivo', 'transferencia', 'tarjeta'),
    in p_referencia varchar(30)
)
begin
    insert into Pago (id_Residente, clasificacion_Pago, monto, fecha_Pago, metodo, referencia)
    values (p_id_Residente, p_clasificacion_Pago, p_monto, p_fecha_Pago, p_metodo, p_referencia);
    select last_insert_id() as id_Pago;
end $$
delimiter ;

-- Delete --
delimiter $$
create procedure sp_Pago_delete(in p_id_Pago int)
begin
    delete from Pago where id_Pago = p_id_Pago;
    select row_count() as filas_afectadas;
end $$
delimiter ;

-- Read --
delimiter $$
create procedure sp_Pago_read_all()
begin
    select * from Pago order by id_Pago;
end $$
delimiter ;

-- Update --
delimiter $$
create procedure sp_Pago_update(
    in p_id_Pago int,
    in p_id_Residente int,
    in p_clasificacion_Pago enum('multa', 'mantenimiento', 'amenidad'),
    in p_monto decimal(12,2),
    in p_fecha_Pago date,
    in p_metodo enum('efectivo', 'transferencia', 'tarjeta'),
    in p_referencia varchar(30)
)
begin
    update Pago
    set id_Residente = p_id_Residente,
		clasificacion_Pago = p_clasificacion_Pago,
        monto = p_monto,
        fecha_Pago = p_fecha_Pago,
        metodo = p_metodo,
        referencia = p_referencia
    where id_Pago = p_id_Pago;
    select row_count() as filas_afectadas;
end $$
delimiter ;

CALL sp_casa_create('C001','Zona 1, Av 1','ocupada','Ana López',250000.00);
CALL sp_casa_create('C002','Zona 2, Calle 3','disponible','Carlos Méndez',310500.00);
CALL sp_casa_create('C003','Zona 3, Av 5','mantenimiento','María Pérez',275900.00);
CALL sp_casa_create('C004','Zona 4, Calle 1','ocupada','Luis García',420000.00);
CALL sp_casa_create('C005','Zona 5, Av 2','disponible','Sofía Ramírez',198750.00);
CALL sp_casa_create('C006','Zona 6, Calle 8','ocupada','Jorge Castillo',365000.00);
CALL sp_casa_create('C007','Zona 7, Av 4','mantenimiento','Paola Díaz',289999.99);
CALL sp_casa_create('C008','Zona 8, Calle 6','disponible','Miguel Hernández',330250.50);
CALL sp_casa_create('C009','Zona 9, Av 3','ocupada','Elena Morales',410800.00);
CALL sp_casa_create('C010','Zona 10, Calle 2','disponible','Ricardo Flores',299000.00);

CALL sp_seguridad_create('Juan Pérez', 'Guardia de Garita', 'dia', 3500.00, '5544-3322');
CALL sp_seguridad_create('Roberto Gómez', 'Vigilante Nocturno', 'noche', 3800.00, '4433-2211');
CALL sp_seguridad_create('Carlos Méndez', 'Supervisor', 'dia', 4500.00, '3322-1100');
CALL sp_seguridad_create('Luis Hernández', 'Operador CCTV', 'noche', 3600.00, '2211-0099');
CALL sp_seguridad_create('Mario Estrada', 'Patrullero', 'noche', 3700.00, '1100-9988');
CALL sp_seguridad_create('Fernando Ruiz', 'Guardia de Garita', 'dia', 3500.00, '9988-7766');
CALL sp_seguridad_create('Jorge Blanco', 'Vigilante Nocturno', 'noche', 3800.00, '8877-6655');
CALL sp_seguridad_create('Samuel Sosa', 'Rondín', 'dia', 3400.00, '7766-5544');
CALL sp_seguridad_create('Ricardo Paz', 'Seguridad Perimetral', 'noche', 3750.00, '6655-4433');
CALL sp_seguridad_create('Héctor Lima', 'Jefe de Seguridad', 'dia', 5000.00, '5544-4433');

CALL sp_limpieza_create('Ana Martínez', 'Conserje Áreas Verdes', 'manana', 3200.00, '5566-7788');
CALL sp_limpieza_create('María López', 'Mantenimiento', 'tarde', 3200.00, '4455-6677');
CALL sp_limpieza_create('Elena Rodríguez', 'Jefe de Cuadrilla', 'manana', 4000.00, '3344-5566');
CALL sp_limpieza_create('José García', 'Recolector', 'tarde', 3300.00, '2233-4455');
CALL sp_limpieza_create('Lucía Torres', 'Auxiliar', 'manana', 3100.00, '1122-3344');
CALL sp_limpieza_create('Marta Quiñónez', 'Limpieza Salones', 'tarde', 3150.00, '9900-1122');
CALL sp_limpieza_create('Pedro Alvarado', 'Jardinero', 'manana', 3400.00, '8899-2233');
CALL sp_limpieza_create('Sofía Méndez', 'Limpieza Oficinas', 'manana', 3100.00, '7788-3344');
CALL sp_limpieza_create('Raúl Cano', 'Mantenimiento General', 'tarde', 3250.00, '6677-4455');
CALL sp_limpieza_create('Clara Villeda', 'Conserje', 'manana', 3100.00, '5566-5566');

CALL sp_amenidad_create('Piscina','06:00 - 18:00',25.00,'disponible',30);
CALL sp_amenidad_create('Gimnasio','05:00 - 22:00',0.00,'disponible',20);
CALL sp_amenidad_create('Salón Social','08:00 - 23:00',150.00,'ocupado',50);
CALL sp_amenidad_create('Cancha de Fútbol','07:00 - 20:00',40.00,'mantenimiento',22);
CALL sp_amenidad_create('Parque Infantil','06:00 - 19:00',0.00,'disponible',40);
CALL sp_amenidad_create('Cancha de Tenis','07:00 - 20:00',35.00,'disponible',4);
CALL sp_amenidad_create('Área de BBQ','09:00 - 21:00',20.00,'ocupado',10);
CALL sp_amenidad_create('Jacuzzi','08:00 - 20:00',15.00,'disponible',6);
CALL sp_amenidad_create('Sala de Juegos','10:00 - 22:00',10.00,'mantenimiento',15);
CALL sp_amenidad_create('Estudio Comunitario','06:00 - 22:00',5.00,'disponible',12);

CALL sp_multa_create(150.00,'Estacionarse en lugar prohibido','2026-01-10','pendiente','visita');
CALL sp_multa_create(300.00,'Ruido excesivo','2026-01-15','pagado','residente');
CALL sp_multa_create(200.00,'Basura fuera de horario','2026-01-18','pendiente','residente');
CALL sp_multa_create(500.00,'Daño a propiedad común','2026-01-20','anulada','visita');
CALL sp_multa_create(120.00,'Mascota sin correa','2026-01-22','pagado','residente');
CALL sp_multa_create(250.00,'Uso indebido de parqueo','2026-01-25','pendiente','visita');
CALL sp_multa_create(180.00,'Alteración del orden','2026-01-28','pagado','residente');
CALL sp_multa_create(400.00,'Modificación sin permiso','2026-02-01','pendiente','residente');
CALL sp_multa_create(220.00,'Invitado no registrado','2026-02-05','pagado','visita');
CALL sp_multa_create(350.00,'Incumplimiento reglamento','2026-02-10','pendiente','residente');

CALL sp_vehiculo_create('P001ABC','Toyota Corolla','Rojo','Ana López',1);
CALL sp_vehiculo_create('P002DEF','Honda Civic','Negro','Carlos Méndez',2);
CALL sp_vehiculo_create('P003GHI','Mazda 3','Blanco','María Pérez',3);
CALL sp_vehiculo_create('P004JKL','Nissan Versa','Azul','Luis García',4);
CALL sp_vehiculo_create('P005MNO','Kia Sportage','Gris','Sofía Ramírez',5);
CALL sp_vehiculo_create('P006PQR','Hyundai Tucson','Rojo','Jorge Castillo',6);
CALL sp_vehiculo_create('P007STU','Ford Escape','Negro','Paola Díaz',7);
CALL sp_vehiculo_create('P008VWX','Volkswagen Golf','Blanco','Miguel Hernández',8);
CALL sp_vehiculo_create('P009YZA','Chevrolet Spark','Azul','Elena Morales',9);
CALL sp_vehiculo_create('P010BCD','Toyota Hilux','Gris','Ricardo Flores',10);

CALL sp_residente_create('Juan Pérez','1234567890123','55123456','activo',1);
CALL sp_residente_create('Lucía Gómez','2345678901234','55234567','activo',2);
CALL sp_residente_create('Pedro Ruiz','3456789012345','55345678','inactivo',3);
CALL sp_residente_create('Carla Soto','4567890123456','55456789','activo',4);
CALL sp_residente_create('Diego López','5678901234567','55567890','activo',5);
CALL sp_residente_create('Valeria Paz','6789012345678','55678901','inactivo',6);
CALL sp_residente_create('Andrés León','7890123456789','55789012','activo',7);
CALL sp_residente_create('Fernanda Gil','8901234567890','55890123','activo',8);
CALL sp_residente_create('Kevin Cruz','9012345678901','55901234','inactivo',9);
CALL sp_residente_create('Diana Rivas','0123456789012','55012345','activo',10);

CALL sp_Visita_create('Carlos Ruiz',       '1234567890', 'ABC-123', 'Visita familiar a residente',          1);
CALL sp_Visita_create('María Fernández',   '0987654321', 'XYZ-456', 'Entrega de paquete',                   2);
CALL sp_Visita_create('Jorge Salazar',     '1122334455', 'QRS-789', 'Revisión de instalaciones eléctricas', 3);
CALL sp_Visita_create('Lucía Monterroso',  '5544332211', 'LMN-321', 'Visita de negocios',                   4);
CALL sp_Visita_create('Pedro Aguilar',     '6677889900', 'DEF-654', 'Reunión con propietario',              5);
CALL sp_Visita_create('Sofía Castellanos', '9988776655', 'GHI-987', 'Servicio de mantenimiento de jardín',  6);
CALL sp_Visita_create('Andrés López',      '4433221100', 'JKL-147', 'Inspección técnica de plomería',       7);
CALL sp_Visita_create('Valeria Moreno',    '3322110099', 'OPQ-258', 'Visita médica a domicilio',            8);
CALL sp_Visita_create('Roberto Fuentes',   '2211009988', 'RST-369', 'Reparación de electrodomésticos',      9);
CALL sp_Visita_create('Diana Herrera',     '1100998877', 'UVW-741', 'Entrega de documentos legales',       10);

CALL sp_accesos_create('visita',    1,  '2025-06-01 06:05:00', '2025-06-01 08:30:00');
CALL sp_accesos_create('residente', 2,  '2025-06-01 22:10:00', '2025-06-01 23:45:00');
CALL sp_accesos_create('personal',  3,  '2025-06-02 07:00:00', '2025-06-02 15:00:00');
CALL sp_accesos_create('visita',    4,  '2025-06-02 21:30:00', '2025-06-02 22:00:00');
CALL sp_accesos_create('residente', 5,  '2025-06-03 20:15:00', '2025-06-03 21:00:00');
CALL sp_accesos_create('personal',  6,  '2025-06-03 06:50:00', '2025-06-03 14:50:00');
CALL sp_accesos_create('visita',    7,  '2025-06-04 23:00:00', NULL);
CALL sp_accesos_create('residente', 8,  '2025-06-04 07:45:00', '2025-06-04 09:00:00');
CALL sp_accesos_create('personal',  9,  '2025-06-05 22:00:00', '2025-06-05 23:30:00');
CALL sp_accesos_create('visita',    10, '2025-06-05 08:00:00', NULL);

CALL sp_pago_create(1,'multa',150.00,'2026-01-11','efectivo','REF001');
CALL sp_pago_create(2,'mantenimiento',500.00,'2026-01-12','transferencia','REF002');
CALL sp_pago_create(3,'amenidad',75.00,'2026-01-15','tarjeta','REF003');
CALL sp_pago_create(1,'multa',300.00,'2026-01-16','efectivo','REF004');
CALL sp_pago_create(4,'mantenimiento',500.00,'2026-01-20','transferencia','REF005');
CALL sp_pago_create(5,'amenidad',100.00,'2026-01-25','tarjeta','REF006');
CALL sp_pago_create(2,'multa',200.00,'2026-02-01','efectivo','REF007');
CALL sp_pago_create(3,'mantenimiento',500.00,'2026-02-05','transferencia','REF008');
CALL sp_pago_create(4,'amenidad',80.00,'2026-02-08','tarjeta','REF009');
CALL sp_pago_create(5,'multa',220.00,'2026-02-12','efectivo','REF010');
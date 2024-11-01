-- criação do esquema de banco de dados
CREATE DATABASE hospedar_db;
USE hospedar_db;
-- CRIAÇÃO DE TABELAS
CREATE TABLE Hotel(
	hotel_id int primary key auto_increment,
    nome varchar(255) NOT NULL, 
    cidade varchar(255) not null,
    uf char(2) not null,
    classificacao int not null check (classificacao between 1 and 5)
);

create table quarto (
	quarto_id int primary key auto_increment,
    hotel_id int not null,
    numero int not null,
    tipo varchar(50) not null,
    preco_diaria decimal(10, 2) not null,
    foreign key (hotel_id) references hotel(hotel_id)
);

create table cliente (
	cliente_id int primary key auto_increment,
    nome varchar(255) not null,
    email varchar(255) not null unique,
    telefone varchar(20) not null,
    cpf varchar (14) not null unique
);

create table Hospedagem (
	hospedagem_id int primary key auto_increment,
    cliente_id int not null,
    quarto_id int not null,
    dt_checkin date not null,
    dt_checkout date not null,
    valor_total_hosp float not null,
    status_hosp varchar(20) not null check (status_hosp in ('reserva', 'finalizada', 'hospedado', 'cancelada')),
    foreign key (cliente_id) references Cliente(cliente_id),
    foreign key (quarto_id) references Quarto(quarto_id)
);

-- Inserção de dados artificiais
-- inserindo dados na tabela Hotel

insert into Hotel (nome, cidade, uf, classificacao) values
('Hotel A', 'Sao Paulo', 'SP', 5),
('Hotel B', 'Rio de Janeiro', 'RJ', 4);

insert into Quarto (hotel_id, numero, tipo, preco_diaria) values
(1, 101, 'Standart', 150.00),
(1, 102, 'Deluxe', 250.00),
(1, 103, 'Suite', 400.00),
(1, 104, 'Standart', 150.00),
(1, 105, 'Deluxe', 250.00),
(2, 201, 'Standart', 130.00),
(2, 202, 'Deluxe', 230.00),
(2, 203, 'Suite', 380.00),
(2, 204, 'Standart', 130.00),
(2, 205, 'Deluxe', 230.00);

-- inserindo dados na tabela Cliente

insert into Cliente (nome, email, telefone, cpf) values
('Cliente 1', 'cliente1@example.com', '11987654321', '12345678901'),
('Cliente 2', 'cliente2@example.com', '21987654321', '12345678902'),
('Cliente 3', 'cliente3@example.com', '31987654321', '12345678903');

-- inserindo dados na tabela hospedagem

insert into Hospedagem (cliente_id, quarto_id, dt_checkin, dt_checkout, valor_total_hosp, status_hosp) values
(1, 101, '2024-01-01', '2024-01-05', 600.00, 'finalizada'),
(1, 102, '2024-01-06', '2024-01-10', 1000.00, 'finalizada'),
(1, 103, '2024-02-01', '2024-02-05', 1600.00, 'finalizada'),
(2, 201, '2024-03-01', '2024-03-05', 520.00, 'finalizada'),
(2, 202, '2024-03-06', '2024-03-10', 920.00, 'finalizada'),
(3, 101, '2024-04-01', '2024-04-05', 600.00, 'reserva'),
(3, 102, '2024-04-06', '2024-04-10', 1000.00, 'reserva'),
(3, 103, '2024-05-01', '2024-05-05', 1600.00, 'reserva'),
(1, 201, '2024-06-01', '2024-06-05', 520.00, 'reserva'),
(1, 202, '2024-06-06', '2024-06-10', 920.00, 'reserva'),
(2, 101, '2024-07-01', '2024-07-05', 600.00, 'hospedado'),
(2, 102, '2024-07-06', '2024-07-10', 1000.00, 'hospedado'),
(2, 103, '2024-08-01', '2024-08-05', 1600.00, 'hospedado'),
(3, 201, '2024-09-01', '2024-09-05', 520.00, 'hospedado'),
(3, 202, '2024-09-06', '2024-09-10', 920.00, 'hospedado'),
(1, 101, '2024-10-01', '2024-10-05', 600.00, 'cancelada'),
(1, 102, '2024-10-06', '2024-10-10', 1000.00, 'cancelada'),
(1, 103, '2024-11-01', '2024-11-05', 1600.00, 'cancelada'),
(2, 201, '2024-12-01', '2024-12-05', 520.00, 'cancelada'),
(2, 202, '2024-12-06', '2024-12-10', 920.00, 'cancelada');

/*Consultas SQL
Listar todos os hoteis e seus respectivos quartos */

select h.nome as hotel_nome, h.cidade, q.tipo, q.preco_diaria
from Hotel h
join Quarto q on h.hotel_id = q.hotel_id;

/* listar todos os clientes com hospedagens finalizadas*/

select c.nome as cliente_nome, q.tipo as quarto_tipo, h.nome as hotel_nome
from Cliente c
join Hospedagem hs on c.cliente_id = hs.cliente_id
join Quarto q on hs.quarto_id = q.quarto_id
join Hotel h on q.hotel_id = h.hotel_id
where hs.status_hosp = 'finalizada';

-- historico de hospedagens d eum cliente especifico

select hs.hospedagem_id, hs.dt_checkin, hs.checkout, q.numero as quarto_numero, h.home as hotel_nome, hass.status_hosp
from Hospedagem hs
join Cliente c on hs.cliente_id = c.cliente_id
join Quarto c on hs.quarto_is = q.quarto_id
join hotel h on q.hotel_id = h.hotel_id
where c.nome = 'Cliente 1'
order by hs.dt_checkin;

-- clientes com hospedagem cancelada

select c.nome as cliente_nome, q.tipo as quarto_tipo, h.nome as hotel_nome
from Cliente c
join hospedagem hs on c.cliente_id = hs.cliente_id
join Quarto q on hs.quarto_id = hs.quarto_id
join Hotel h on q.hotel_id = h.hotel_id
where hs.status_hosp = 'cancelada';

-- receita de todos os hoteis

select h.nome as hotel_nome, sum(hs.valor_total_hosp) as receita_total
from Hotel h
join Quarto q on h.hotel_id = q.hotel_id
join Hospedagem hs on q.quarto_id = hs.quarto_id
where hs.status_hosp = 'finalizada'
group by h.nome
order by receita_total desc;

-- clientes que ja fizeram reserva em um hotel especifico

select c.nome as cliente_nome
from Cliente c
join Hospedagem hs on c.cliente_id = hs.cliente_id
join quarto q on hs.quarto_id = q.quarto_id
join Hotel h on q.hotel_id = h.hotel_id
where h.nome = 'Hotel A' and hs.status_hosp = 'reserva';

-- gasto total de cada cliente

select c.nome as cliente_nome, sum(hs.valor_total_hosp) as gasto_total
from Cliente c
join Hospedagem hs on c.cliente_id = hs.cliente_id
where hs.status_hosp = 'finalizada'
group by c.nome
order by gasto_total desc;

-- quartos que não receberam hospedes

select q.quarto_id, q.numero, q.tipo, h.nome as hotel_nome
from Quarto q
left join Hospedagem hs on q.quarto_id = hs.quarto_id
join Hotel1 h on q.hotel_id = h.hotel_id
where hs.hospedagem_id is null;

-- média de preços de diárias por tipo de quarto
select q.tipo, avg(q.preco_diaria) as media_precco_diaria
from Quarto q
group by q.tipo;

-- método de vendas direta de cupons para os hoteis

select q.tipo, avg(q.cupom_desconto) as cupom_desc
from hotel.id
group by q.desc;


-- criar coluna checkin_atualizado e atribuir valores

alter table Hospedagem add column checkin_realizado boolean;

update Hospedagem
set checkin_realizado = case
	when status_hosp in ('finalizada', 'hospeddado') then true
    else false
end;

-- mudar o nome da coluna classificacao para ratting
alter table hotel change classificacao ratting int;

/*PROCEDIMENTOS PL/MySQL
procedure registrarCheckin*/

delimiter //
create procedure registrarCheckin (in p_hospedagem_id int, in p_dt_checkin date)
begin
	update Hospedagem
    set dt_checkin = p_dt_checkin, status_hosp = 'hospedado'
    where hospedagem_id = p_hospedagem_id;
end //
delimiter //

-- procedure CalcularTotal1Hospedagem 
delimiter //

CREATE PROCEDURE CalcularTotalHospedagem (IN p_hospedagem_id INT)
BEGIN
    DECLARE v_preco_diaria DECIMAL(10, 2);
    DECLARE v_dias INT;
    
    SELECT q.preco_diaria
    INTO v_preco_diaria
    FROM Hospedagem hs
    JOIN Quarto q ON hs.quarto_id = q.quarto_id
    WHERE hs.hospedagem_id = p_hospedagem_id;
    
    SELECT DATEDIFF(dt_checkout, dt_checkin)
    INTO v_dias
    FROM Hospedagem
    WHERE hospedagem_id = p_hospedagem_id;
    
    UPDATE Hospedagem
    SET valor_total_hosp = v_dias * v_preco_diaria
    WHERE hospedagem_id = p_hospedagem_id;
END //

delimiter ;

-- procedure RegistrarCheckout

delimiter // 
create procedure RegistrarCheckout (in p_hospedagem_id int, in p_dt_checkout date)
begin
	update Hospedagem
    set dt_checkout = p_dt_checkout, status_hosp = 'finalizada'
    where hospedagem_id = p_hospedagem_id;
end // 

delimiter ;

DELIMITER //

CREATE FUNCTION TotalHospedagensHotel (p_hotel_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    
    SELECT COUNT(hs.hospedagem_id)
    INTO v_total
    FROM Hospedagem hs
    JOIN Quarto q ON hs.quarto_id = q.quarto_id
    WHERE q.hotel_id = p_hotel_id;
    
    RETURN v_total;
END //

DELIMITER ;

-- Função valor medio diario
delimiter //
create function ValorMedioDiariasHotel (p_hotel_id int)
returns decimal(10, 2)
deterministic
begin
	declare v_media decimal (10, 2);
    
    select avg(q.preco_diaria)
    into v_media
    from Quarto q
    where q.hotel_id = p_hotel_id;
    
    return v_meida;
end //

delimiter ;

-- Função verificar disponibilidade quarto

DELIMITER //

CREATE FUNCTION VerificarDisponibilidadeQuarto (p_quarto_id INT, p_data DATE)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_disponivel BOOLEAN;
    
    IF NOT EXISTS (
        SELECT 1
        FROM Hospedagem hs
        WHERE hs.quarto_id = p_quarto_id
        AND p_data BETWEEN hs.dt_checkin AND hs.dt_checkout
    ) THEN
        SET v_disponivel = TRUE;
    ELSE
        SET v_disponivel = FALSE;
    END IF;
    
    RETURN v_disponivel;
END //

DELIMITER ;

/* triggers pl/ mysql
trigger antes de inserir hospedagem*/

delimiter // 
create trigger AntesDeIncerirHospedagem
before insert on Hospedagem
for each row
begin
	declare v_disponivel boolean;
    set v_disponivel = VerificarDisponibilidadeQuarto (new.quarto_id, new.dt_checkin);
    if v_disponivel = false then
		signal sqlstate '45000'
        set message_text = 'Quarto não está disponivel na data de check-in';
	end if;
end //

delimiter ;

-- trigger Apos deletar cliente

create table LogExclusaoCliente (
	log_id int primary key auto_increment,
    cliente_id int,
    data_exclusao timestamp default current_timestamp
);

delimiter //

create trigger AposDeletarCliente
after delete on Cliente
for each row
begin
	insert into LogExclusaoCliente (cliente_id)
    values (old.cliente_id);
end // 

delimiter ;
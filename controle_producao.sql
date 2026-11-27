-- Active: 1794483871965@@127.0.0.1@3308@projeto_producao
CREATE DATABASE if NOT EXISTS Projeto_Producao;
use Projeto_Producao;


CREATE TABLE if NOT EXISTS operadores (
    id_operador int AUTO_INCREMENT,
    nome  VARCHAR(60) not NULL,
    telefone VARCHAR(15),
    turno VARCHAR(50) not NULL,
    constraint pk_operadores PRIMARY KEY (id_operador)
);



CREATE Table if not exists maquina (
    id_maquina int AUTO_INCREMENT,
    status_maquina ENUM ("Ligado","Desligado"),
    modelo VARCHAR(180) not NULL,
    constraint pk_maquina PRIMARY KEY (id_maquina),
    id_operador INT not NULL,
    constraint fk_operador_maquina FOREIGN KEY (id_operador) REFERENCES operadores (id_operador)
);

ALTER TABLE maquina
DROP FOREIGN KEY fk_operador_maquina;
ALTER TABLE maquina
DROP COLUMN id_operador;


CREATE Table if not exists produto (
    id_produto INT AUTO_INCREMENT,
    quantidade int not NULL,
    descricao  VARCHAR (120) not NULL,
    preco  DECIMAL(10,2) not NULL,
    constraint pk_produto PRIMARY KEY (id_produto)
);

ALTER TABLE produto
DROP COLUMN quantidade;

ALTER TABLE operadores
ADD CONSTRAINT chk_turno
CHECK (turno IN ('diurno', 'noturno'));

CREATE Table if NOT exists ordem_producao(
    id_ordem int AUTO_INCREMENT,
    prioridade ENUM ("Alta","Baixa"),
    data_inicio DATE NOT NULL,
    prazo  DATE not NULL,
    constraint pk_ordem PRIMARY KEY (id_ordem),
    id_operador int not NULL,
    constraint fk_operadores_ordem FOREIGN KEY (id_operador) REFERENCES operadores (id_operador),
    id_maquina int NOT NULL,
    constraint fk_maquina_ordem FOREIGN KEY (id_maquina) REFERENCES maquina (id_maquina)
);

CREATE TABLE IF NOT EXISTS item_producao (
    id_producao INT AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    turno_producao VARCHAR(15) NOT NULL,
    status_producao VARCHAR(10) NOT NULL DEFAULT 'Ativa',

    CONSTRAINT pk_item_producao 
        PRIMARY KEY (id_producao),

    CONSTRAINT chk_quantidade 
        CHECK (quantidade > 0),

    CONSTRAINT chk_status_producao 
        CHECK (status_producao IN ('Ativa', 'Inativa')),

    CONSTRAINT fk_ordem_producao 
        FOREIGN KEY (id_ordem) 
        REFERENCES ordem_producao (id_ordem),

    CONSTRAINT fk_produto_producao 
        FOREIGN KEY (id_produto) 
        REFERENCES produto (id_produto)
);


INSERT INTO operadores (nome, telefone, turno) VALUES
('Carlos Silva', '(11) 98765-4321', 'diurno'),
('Marina Souza', '(11) 91234-5678', 'noturno'),
('João Pereira', '(11) 99876-5432', 'diurno'),
('Fernanda Lima', '(19) 98123-4567', 'noturno'),
('Rafael Oliveira', '(11) 97654-3210', 'diurno'),
('Patrícia Santos', '(19) 99234-8765', 'noturno'),
('Lucas Almeida', '(11) 96543-2109', 'diurno'),
('Juliana Costa', '(15) 98432-1098', 'noturno'),
('Bruno Rodrigues', '(11) 95432-1987', 'diurno'),
('Camila Ferreira', '(19) 97321-0876', 'noturno');


INSERT INTO maquina (status_maquina, modelo) VALUES
('Ligado', 'Torno CNC Romi GL 240'),
('Desligado', 'Fresadora Industrial D800'),
('Ligado', 'Centro de Usinagem Haas VF-2'),
('Ligado', 'Prensa Hidráulica Ribeiro 100T'),
('Desligado', 'Retífica Cilíndrica Sulmecânica RCS 1000');



INSERT INTO produto (descricao, preco) VALUES
('Engrenagem de aço 20 dentes', 45.90),
('Eixo de transmissão 300mm', 128.50),
('Rolamento de esferas 6205', 32.75),
('Parafuso sextavado M10 x 50mm (caixa)', 18.90),
('Polia de alumínio 120mm', 67.40),
('Bucha de bronze 25mm', 24.30),
('Mola de compressão 40mm', 9.80),
('Flange de aço carbono 4 polegadas', 89.00),
('Pino guia temperado 8mm', 14.60),
('Correia dentada industrial HTD 5M', 54.20);



INSERT INTO ordem_producao (prioridade, data_inicio, prazo, id_operador, id_maquina) VALUES
('Alta',  '2026-11-27', '2026-12-10', 1, 1),
('Baixa', '2026-11-30', '2026-12-20', 2, 2),
('Alta',  '2026-12-01', '2026-12-12', 3, 3),
('Baixa', '2026-12-02', '2026-12-22', 4, 4),
('Alta',  '2026-12-03', '2026-12-15', 5, 5),
('Baixa', '2026-12-04', '2026-12-28', 6, 1),
('Alta',  '2026-12-07', '2026-12-18', 7, 2),
('Baixa', '2026-12-08', '2026-12-30', 8, 3),
('Alta',  '2026-12-09', '2026-12-19', 9, 4),
('Baixa', '2026-12-10', '2027-01-08', 10, 5);


INSERT INTO item_producao (id_ordem, id_produto, quantidade, turno_producao, status_producao) VALUES
(1, 1, 500, 'diurno',  'Ativa'),
(2, 3, 250, 'noturno', 'Ativa'),
(3, 5, 120, 'diurno',  'Inativa'),
(4, 8, 80,  'noturno', 'Ativa'),
(5, 10, 300, 'diurno', 'Ativa');



-- SQL
UPDATE produto
SET preco = 48.00
WHERE id_produto = 1;


DELETE FROM item_producao
WHERE id_producao = 5;


-- DQL

SELECT
    op.id_ordem,
    op.prioridade,
    op.data_inicio,
    op.prazo,
    o.nome AS operador,
    m.modelo AS maquina
FROM ordem_producao op
JOIN operadores o
    ON o.id_operador = op.id_operador
JOIN maquina m
    ON m.id_maquina = op.id_maquina;


-- TCL

START TRANSACTION;

INSERT INTO item_producao
(id_ordem, id_produto, quantidade, turno_producao)
VALUES
(1, 2, 50, 'diurno');

COMMIT;



CREATE INDEX idx_ordem_data
ON ordem_producao(data_inicio);

CREATE INDEX idx_ordem_operador
ON ordem_producao(id_operador);

CREATE INDEX idx_item_produto
ON item_producao(id_produto);

EXPLAIN
SELECT *
FROM ordem_producao
WHERE data_inicio = '2026-11-27';


Nesta api foi utilizada um bd em postgres;

Seguinte estrutura:

CREATE SEQUENCE usuario_id_seq;

CREATE TABLE IF NOT EXISTS usuario (
	id INT NOT NULL DEFAULT nextval('usuario_id_seq'), 
	nome VARCHAR(200) NOT NULL, 
	email VARCHAR(200) NOT NULL, 
	senha VARCHAR(200) NOT NULL, 
	PRIMARY KEY (id)
);

ALTER SEQUENCE usuario_id_seq
OWNED BY usuario.id;

CREATE SEQUENCE produto_id_seq;

CREATE TABLE IF NOT EXISTS produto (
	id INT NOT NULL DEFAULT nextval('produto_id_seq'), 
	nome VARCHAR(255) NOT NULL, 
	descricao TEXT NOT NULL, 
	preco DECIMAL(10,2) NOT NULL, 
	imagem TEXT NULL, 
	PRIMARY KEY (id)
);

ALTER SEQUENCE produto_id_seq
OWNED BY produto.id;

CREATE SEQUENCE pedido_id_seq;
CREATE TABLE IF NOT EXISTS pedido ( 
	id INT NOT NULL DEFAULT nextval('pedido_id_seq'), 
	usuario_id INT NOT NULL, 
	id_transacao TEXT NULL, 
	cpf_cliente VARCHAR(45) NULL, 
	endereco_entrega TEXT NOT NULL, 
	status_pedido VARCHAR(20) NOT NULL DEFAULT 'pendente', 
	PRIMARY KEY (id),
	CONSTRAINT fk_pedido_usuario FOREIGN KEY (usuario_id) 
	REFERENCES usuario (id) ON DELETE NO ACTION ON UPDATE NO ACTION);

create INDEX fk_pedido_usuario_idx on pedido (usuario_id ASC);

ALTER SEQUENCE pedido_id_seq
OWNED BY pedido.id;

CREATE SEQUENCE pedido_item_id_seq;
CREATE TABLE IF NOT EXISTS pedido_item (
	id INT NOT NULL DEFAULT nextval('pedido_item_id_seq'), 
	quantidade VARCHAR(45) NOT NULL, 
	pedido_id INT NOT NULL, produto_id INT NOT NULL, 
	PRIMARY KEY (id),
	CONSTRAINT fk_pedido_produto_pedido1 FOREIGN KEY (pedido_id) 
	REFERENCES pedido (id) ON DELETE NO ACTION ON UPDATE NO ACTION, 
	CONSTRAINT fk_pedido_produto_produto1 FOREIGN KEY (produto_id) 
	REFERENCES produto (id) ON DELETE NO ACTION ON UPDATE NO ACTION);

create INDEX fk_pedido_produto_pedido1_idx on pedido_item (pedido_id ASC);
create INDEX fk_pedido_produto_produto1_idx on pedido_item(produto_id ASC);

ALTER SEQUENCE pedido_item_id_seq
OWNED BY pedido_item.id;

INSERT INTO produto(nome, descricao, preco, imagem) VALUES ('X-Tudão + Suco', '', 12.99, '/xtudo_suco.jpeg');

INSERT INTO produto(nome, descricao, preco, imagem) VALUES ('Misto Quente', 'Pão, presunto, muçarela, Orégano', 6.99, '/xtudo_suco.jpeg');

INSERT INTO produto(nome, descricao, preco, imagem) VALUES ('X-Quente', 'Pão, Hambúrger (Tradicional 56g), Muçarela e Tomate', 10.99, '/xtudo_suco.jpeg');

INSERT INTO produto(nome, descricao, preco, imagem) VALUES ('X-Salada', 'Pão, Hambúrguer (Tradicional 56g), Presunto, Muçarela, Ovo, Alface, Tomate, Milho e Batata Palha.', 11.99, '/xtudo_suco.jpeg');

INSERT INTO produto(nome, descricao, preco, imagem) VALUES ('X-Tudo', 'Pão, Hambúrguer (Tradicional 56g), Presunto, Muçarela, Salsicha, Bacon, Calabresa, Ovo, Catupiry, Alface, Tomate, Milho e Batata Palha.', 15.99, '/xtudo_suco.jpeg');

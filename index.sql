CREATE TABLE Departamentos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);


CREATE TABLE Funcionarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    departamento_id INT,
    FOREIGN KEY (departamento_id) REFERENCES Departamentos(id)
);

CREATE TABLE Projetos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    funcionario_id INT,
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(id)
);

CREATE TABLE LogAcao (
    id SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Departamentos (nome) 
VALUES
('Recursos Humanos'),
('Desenvolvimento'),
('Marketing');

INSERT INTO Funcionarios (nome, idade, departamento_id) VALUES
('Alice', 30, 1),
('Bob', 25, 2),
('Carlos', 28, 3),
('Diana', 35, 2);

INSERT INTO Projetos (nome, funcionario_id) VALUES
('Projeto A', 1),
('Projeto B', 2),
('Projeto C', 2),
('Projeto D', 3);

SELECT f.nome AS NomeFuncionario, f.idade, d.nome AS NomeDepartamento
FROM Funcionarios f
JOIN Departamentos d ON f.departamento_id = d.id;

SELECT p.nome AS NomeProjeto, f.nome AS NomeFuncionario
FROM Projetos p
JOIN Funcionarios f ON p.funcionario_id = f.id;

SELECT f.nome AS NomeFuncionario, d.nome AS NomeDepartamento, p.nome AS NomeProjeto
FROM Funcionarios f
JOIN Departamentos d ON f.departamento_id = d.id
JOIN Projetos p ON f.id = p.funcionario_id;

CREATE OR REPLACE FUNCTION log_funcionario_insercao()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO LogAcao (descricao) VALUES ('Novo funcionário inserido: ' || NEW.nome);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criação do Trigger
CREATE TRIGGER after_insert_funcionario
AFTER INSERT ON Funcionarios
FOR EACH ROW
EXECUTE FUNCTION log_funcionario_insercao();

-- Verificação do Trigger
INSERT INTO Funcionarios (nome, idade, departamento_id) VALUES
('Eva', 29, 1);

SELECT * FROM LogAcao;

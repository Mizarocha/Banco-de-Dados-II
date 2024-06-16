/*Uma empresa de vendas tem um banco de dados com informações sobre os seus produtos. 
Ela precisa criar um relatório que faça um levantamento diário da quantidade de produtos comprados por dia. 
Para ajudar a empresa, crie um procedure para agilizar esse processo.*/



CREATE TABLE daily_sales_report (
    report_date DATE,
    product_id INT,
    product_name VARCHAR(255),
    total_quantity INT,
    PRIMARY KEY (report_date, product_id)
);


CREATE PROCEDURE GenerateDailySalesReport (IN reportDate DATE)
BEGIN
    -- Limpar dados antigos do relatório para a data especificada
    DELETE FROM daily_sales_report WHERE report_date = reportDate;

    -- Inserir dados no relatório diário
    INSERT INTO daily_sales_report (report_date, product_id, product_name, total_quantity)
    SELECT
        s.sale_date AS report_date,
        p.product_id,
        p.product_name,
        SUM(s.quantity) AS total_quantity
    FROM
        sales s
    JOIN
        products p ON s.product_id = p.product_id
    WHERE
        s.sale_date = reportDate
    GROUP BY
        s.sale_date, p.product_id, p.product_name;


END



use superstore;

-- ----------------------------------------------////////////////////////////////////////////////////////////////////////////
/*  
Quais categorias e subcategorias dão prejuízo mesmo tendo
volume de vendas alto? Por quê isso acontece?
*/
-- conhecer a estrutura do banco
select * from superstore limit 15; 

-- conhecendo as categorias e suas subcategorias
select distinct category, sub_category from superstore order by category; 

-- Calcula quanto as categorias vendem, geram de lucro, a margem percentual de lucro e a média de desconto aplicada
select category as categoria, 
       count(*) as quantidade_total_de_vendas , 
       format(sum(sales),2) as total_de_vendas_bruto, 
       format(sum(profit),2) as lucro,
	   concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem_percentual,
       concat(format(avg(discount) * 100, 2), '%') as media_desconto
from superstore group by category
order by sum(profit) desc;

-- Calcula quanto as sub categorias vendem, geram de lucro, a margem percentual de lucro e a média de desconto aplicada
select category as categoria, 
	   sub_category as subcategoria, 
       count(*) as quantidade_total_de_vendas , 
       format(sum(sales),2) as total_de_vendas_bruto, 
       format(sum(profit),2) as lucro,
	   concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem_percentual,
       concat(format(avg(discount) * 100, 2), '%') AS media_desconto
from superstore group by category, sub_category
order by category;


-- Calcula quais subcategorias dão prejuizo
select category as categoria, 
	   sub_category as subcategoria, 
       count(*) as quantidade_total_de_vendas , 
       format(sum(sales),2) as total_de_vendas_bruto, 
       format(sum(profit),2) as lucro,
	   concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem_percentual,
       concat(format(avg(discount) * 100, 2), '%') as media_desconto
from superstore 
group by category, sub_category
having sum(profit) < 0
order by category;

-- ----------------------------------------------////////////////////////////////////////////////////////////////////////////

/*Existe correlação entre nível de desconto aplicado e queda de margem?
 A partir de que faixa de desconto a operação começa a perder dinheiro? */

    
-- calcula num geral em que categoria de desconto se começa a ter prejuizo
    SELECT 
    CASE 
        WHEN discount = 0 THEN '1. Sem Desconto (0%)'
        WHEN discount > 0 AND discount <= 0.20 THEN '2. Baixo (1% a 20%)'
        WHEN discount > 0.20 AND discount <= 0.40 THEN '3. Médio (21% a 40%)'
        ELSE '4. Alto (> 40%)'
    END AS faixa_desconto,
    COUNT(*) AS total_pedidos,
    FORMAT(SUM(sales), 2) AS vendas_totais,
    FORMAT(SUM(profit), 2) AS lucro_total,
    CONCAT(FORMAT((SUM(profit) / SUM(sales)) * 100, 2, 'pt_BR'), '%') AS margem_percentual

FROM superstore
GROUP BY 
    CASE 
        WHEN discount = 0 THEN '1. Sem Desconto (0%)'
        WHEN discount > 0 AND discount <= 0.20 THEN '2. Baixo (1% a 20%)'
        WHEN discount > 0.20 AND discount <= 0.40 THEN '3. Médio (21% a 40%)'
        ELSE '4. Alto (> 40%)'
    END
ORDER BY faixa_desconto ASC;


-- Calcula o lucro em cada subcategoria em relação a faixa de desconto aplicada
   SELECT 
     category,
    sub_category as sub_categoria,
    CASE 
        WHEN discount = 0 THEN '1. Sem Desconto (0%)'
        WHEN discount > 0 AND discount <= 0.20 THEN '2. Baixo (1% a 20%)'
        WHEN discount > 0.20 AND discount <= 0.40 THEN '3. Médio (21% a 40%)'
        ELSE '4. Alto (> 40%)'
    END AS faixa_desconto,
    COUNT(*) AS total_pedidos,
    FORMAT(SUM(sales), 2) AS vendas_totais,
    FORMAT(SUM(profit), 2) AS lucro_total,
    CONCAT(FORMAT((SUM(profit) / SUM(sales)) * 100, 2, 'pt_BR'), '%') AS margem_percentual

FROM superstore
GROUP BY 
sub_category,
category,
faixa_desconto
ORDER BY category asc, sub_category, faixa_desconto;

-- Calcula o lucro em relação a faixa de desconto aplicada apenas nas subcategorias que geram prejuizo num todo

  SELECT 
     category,
    sub_category as sub_categoria,
    CASE 
        WHEN discount = 0 THEN '1. Sem Desconto (0%)'
        WHEN discount > 0 AND discount <= 0.20 THEN '2. Baixo (1% a 20%)'
        WHEN discount > 0.20 AND discount <= 0.40 THEN '3. Médio (21% a 40%)'
        ELSE '4. Alto (> 40%)'
    END AS faixa_desconto,
    COUNT(*) AS total_pedidos,
    FORMAT(SUM(sales), 2) AS vendas_totais,
    FORMAT(SUM(profit), 2) AS lucro_total,
    CONCAT(FORMAT((SUM(profit) / SUM(sales)) * 100, 2, 'pt_BR'), '%') AS margem_percentual

FROM superstore where sub_category in("Bookcases", "Tables", "Supplies")
GROUP BY 
sub_category,
category,
faixa_desconto

ORDER BY category asc, sub_category, faixa_desconto;


-- ----------------------------------------------////////////////////////////////////////////////////////////////////////////

/* Quais estados/regiões são mais lucrativos e quais consistentemente destroem margem? */
    
-- Calcula quanto as regiões vendem, geram de lucro, a margem percentual de lucro e a média de desconto aplicada
    select region,
       count(*) as quantidade_total_de_vendas , 
       format(sum(sales),2) as total_de_vendas_bruto, 
       format(sum(profit),2) as lucro,
	   concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem_percentual,
       concat(format(avg(discount) * 100, 2), '%') as media_desconto
from superstore 
group by region
order by sum(profit) desc;

-- west -- east -- south -- central(o q menos vende e mais tem desconto)



    
  
-- Calcula quanto os estados vendem, geram de lucro, a margem percentual de lucro e a média de desconto aplicada
      select region, state,
       count(*) as quantidade_total_de_vendas , 
       format(sum(sales),2) as total_de_vendas_bruto, 
       format(sum(profit),2) as lucro,
	   concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem_percentual, 
       concat(format(avg(discount) * 100, 2), '%') as media_desconto
from superstore 
group by region, state
order by region, sum(profit) desc;

-- Calcula quais estados geram prejuizo

     select region, state,
       format(sum(sales),2) as total_de_vendas_bruto, 
       format(sum(profit),2) as lucro,
	   concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem_percentual,
       concat(format(avg(discount) * 100, 2), '%') as media_desconto
from superstore
group by region, state
having sum(profit) < 0
order by region, sum(profit) asc;




-- Calcula o lucro nos estados criticos nos anos registrados
select 
    s.region, 
    s.state,
    year(str_to_date(s.order_date, '%m/%d/%Y')) as ano,
    count(*) as quantidade_total_de_vendas, 
    format(sum(s.sales), 2) as total_de_vendas_bruto, 
    format(sum(s.profit), 2) as lucro,
    concat(format((sum(s.profit) / sum(s.sales)) * 100, 2), '%') as margem_percentual,
    concat(format(avg(s.discount) * 100, 2), '%') as media_desconto
from 
    superstore s
inner join 
    estados_ruins er on s.state = er.state
group by 
    s.region, 
    s.state, 
    year(str_to_date(s.order_date, '%m/%d/%Y'))
order by 
    s.region, 
    s.state, 
    ano asc;


-- Mostra os unicos registros dos estados criticos durante os anos em que o lucro se mantem positivo
with estados_ruins as (
    select state 
    from superstore 
    group by state 
    having sum(profit) < 0
)
select 
    s.region, 
    s.state,
    year(str_to_date(s.order_date, '%m/%d/%Y')) as ano,
    count(*) as quantidade_total_de_vendas, 
    format(sum(s.sales), 2) as total_de_vendas_bruto, 
    format(sum(s.profit), 2) as lucro,
    concat(format((sum(s.profit) / sum(s.sales)) * 100, 2), '%') as margem_percentual,
    concat(format(avg(s.discount) * 100, 2), '%') as media_desconto
from 
    superstore s
inner join 
    estados_ruins er on s.state = er.state
group by 
    s.region, 
    s.state, 
    year(str_to_date(s.order_date, '%m/%d/%Y'))
having 
    sum(s.profit) > 0
order by 
    s.region, 
    s.state, 
    ano asc;
    
    
-- Insight adicional

-- descobrindo quem carrega a regiao west nas costas e quem sangra em silencio
select 
    state,
    count(*) as total_pedidos,
    format(sum(sales), 2) as vendas,
    format(sum(profit), 2) as lucro,
    concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem,
    concat(format(avg(discount) * 100, 2), '%') as media_desconto
from 
    superstore
where 
    region = 'west'
group by 
    state
order by 
    sum(profit) desc;
    
    
    -- descobrindo os estados que dao lucro na regiao central mas sao ofuscados pelo texas/illinois
select 
    state,
    count(*) as total_pedidos,
    format(sum(sales), 2) as vendas,
    format(sum(profit), 2) as lucro,
    concat(format((sum(profit) / sum(sales)) * 100, 2), '%') as margem,
    concat(format(avg(discount) * 100, 2), '%') as media_desconto
from 
    superstore
where 
    region = 'central'
group by 
    state
order by 
    sum(profit) desc;

  

  
  
-- ----------------------------------------------////////////////////////////////////////////////////////////////////////////

/* Se a empresa tivesse que cortar 20% do catálogo por baixa rentabilidade, quais produtos/subcategorias entrariam na lista?  */
    
-- Calcula quantos produtos existem na loja
select count(distinct(product_name)) from superstore;

-- calcula quantos produtos equivalem a 20% 
select (count(distinct(product_name))) * 0.2 from superstore;

-- Mostra os 370 produtos e suas vendas, e seu lucro 
select category, sub_category, product_name, format(sum(sales), 2) as venda_bruta, format(sum(profit),2) as lucro,
count(*) as quantidade_de_vendas
from superstore
group by category, sub_category, product_name
order by sum(profit) asc
limit 370;

-- Observa-se que exsitem produtos que nao geram prejuizo nessa lista, entao, nao faz sentido cortar 20% do catalogo


-- consolidacao da auditoria do corte de 20% (370 piores produtos)
with top_370_piores as (
    select 
        product_name,
        round(sum(profit), 2) as lucro_acumulado
    from superstore
    group by product_name
    order by lucro_acumulado asc
    limit 370
)
select 
    case 
        when lucro_acumulado < 0.00 then 'Produtos no Prejuízo Efetivo'
        when lucro_acumulado = 0.00 then 'Produtos no Ponto de Equilíbrio'
        else 'Produtos Rentáveis'
    end as classificacao,
    count(*) as quantidade_produtos,
    concat(format((count(*) / 1850.0) * 100, 2), '%') as representatividade_catalogo,
    format(sum(lucro_acumulado), 2) as lucro_acumulado_total
from top_370_piores
group by 
    case 
        when lucro_acumulado < 0.00 then 'Produtos no Prejuízo Efetivo'
        when lucro_acumulado = 0.00 then 'Produtos no Ponto de Equilíbrio'
        else 'Produtos Rentáveis'
    end
order by min(lucro_acumulado) asc;


-- Mostra os 305 produtos, suas categorias, suas subcategorias, valor de venda e lucro que deveriam ser retirados do catalogo da empresa 
select category, sub_category, product_name, 
format(sum(sales), 2) as venda_bruta, 
format(sum(profit),2) as lucro,
count(*) as quantidade_de_vendas
from superstore
group by category, sub_category, product_name
having round(sum(profit),2) <= 0
order by sum(profit) asc;



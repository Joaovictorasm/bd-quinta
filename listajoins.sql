-- 01
select
	p.nome as pet_nome,
	p.especie as pet_especie,
	p.raca as pet_raca,
	c.nome as dono_nome,
	c.telefone as dono_telefone
from pets p
inner join clientes c
	on p.cliente_id = c.id
	
--02
select
	c.nome as cliente_nome,
	v.data_venda as venda_data,
	p.nome as produto_nome,
	iv.quantidade as item_quantidade,
	iv.preco_unitario as item_preco,
	v.valor_total as venda_total
from vendas v
inner join clientes c
	on v.cliente_id = c.id
inner join itens_venda iv
	on v.id = iv.venda_id
inner join produtos p
	on iv.produto_id = p.id
order by v.data_venda desc
	
--03
select
	c.id as cliente_id,
	c.nome as cliente_nome,
	coalesce(count(v.id), 0) as compras
from clientes c
left join vendas v
	on c.id = v.cliente_id
group by c.id, c.nome

--04
select
	p.id as produto_id,
	p.nome as produto_nome,
	coalesce(count(iv.id), 0) as vendas
from produtos p
left join itens_venda iv 
	on iv.produto_id = p.id
group by p.id, p.nome

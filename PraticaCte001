-- 1
with PrecoMedioProdutosCTE as (
	select
		p.id as produto_id,
		p.nome as produto_nome,
		p.preco as produto_preco
	from produtos p
	group by p.id
)
select * from PrecoMedioProdutosCTE 
where produto_preco > (
	select
		avg(produto_preco)
	from PrecoMedioProdutosCTE 
)

-- 2
with ClientesComPetsCTE as (
	select 
		c.id as cliente_id,
		c.nome as cliente_nome,
		p.nome as pet_nome,
		v.valor_total as total_gasto
	from clientes c
	left join pets p
		on p.cliente_id = c.id
	inner join vendas v
		on v.cliente_id = c.id
)
select * from ClientesComPetsCTE

-- 3
with GastosPorClienteCTE as (
	select
		c.id as cliente_id,
		c.nome as cliente_nome,
		v.valor_total as total_gasto
	from clientes c
	inner join vendas v
		on v.cliente_id = c.id
)
select * from GastosPorClienteCTE 
where total_gasto > (
	select
		avg(total_gasto)
	from GastosPorClienteCTE
)

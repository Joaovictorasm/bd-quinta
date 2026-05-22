--01
create or replace procedure aplicar_desconto(p_id integer, p_percentual numeric)
language plpgsql
as $$
declare
    v_preco_atual numeric;
    v_preco_novo numeric;
begin
    if p_percentual < 1 or p_percentual > 100 then
        raise exception 'O percentual de desconto deve ser entre 1 e 100. Valor informado: %', p_percentual;
    end if;

    if not exists (select 1 from produtos where id = p_id) then
        raise exception 'Produto com ID % não encontrado.', p_id;
    end if;

    select preco into v_preco_atual from produtos where id = p_id;
    
    v_preco_novo := v_preco_atual - (v_preco_atual * (p_percentual / 100.0));

    if v_preco_novo < 1.00 then
        raise exception 'Desconto negado. O preço final (R$ %) ficaria abaixo de R$ 1,00.', round(v_preco_novo, 2);
    end if;

    update produtos 
    set preco = v_preco_novo 
    where id = p_id;
    
    raise notice 'Desconto aplicado com sucesso! Novo preço: R$ %', round(v_preco_novo, 2);
end;
$$;

--02
create or replace procedure cadastrar_agendamento(p_pet_id integer, p_servico_id integer, p_data_agendamento timestamp)
language plpgsql
as $$
begin
    if not exists (select 1 from pets where id = p_pet_id) then
        raise exception 'Pet com ID % não encontrado.', p_pet_id;
    end if;

    if not exists (select 1 from servicos where id = p_servico_id) then
        raise exception 'Serviço com ID % não encontrado.', p_servico_id;
    end if;

    if p_data_agendamento < current_timestamp then
        raise exception 'A data do agendamento não pode ser no passado. Data informada: %', p_data_agendamento;
    end if;

    insert into agendamentos (pet_id, servico_id, data_agendamento)
    values (p_pet_id, p_servico_id, p_data_agendamento);

    raise notice 'Agendamento cadastrado com sucesso para o pet % na data %!', p_pet_id, p_data_agendamento;
end;

--03

create or replace procedure transferir_pet(p_id integer, c_id integer)
language plpgsql
as $$
begin
    if not exists (select 1 from clientes where id = c_id) then 
        raise exception 'Cliente com id % não encontrado.', c_id;
    end if;

    if not exists (select 1 from pets where id = p_id) then
        raise exception 'Pet com id % não encontrado.', p_id;
    end if;

    if exists (select 1 from pets where id = p_id and cliente_id = c_id) then 
        raise exception 'O cliente % já é o dono do pet %.', c_id, p_id;
    end if;

    update pets
    set cliente_id = c_id
    where id = p_id;

    raise notice 'Pet % transferido com sucesso para o cliente %!', p_id, c_id;
end;

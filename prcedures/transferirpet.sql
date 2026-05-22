create or replace procedure transferir_pet(p_id integer, c_id integer)
language plpgsql
as $$
begin
    if not exists (select 1 from clientes where id = c_id) then 
        raise exception 'Cliente com id % não existe.', c_id;
    end if;

    if not exists (select 1 from pets where id = p_id) then
        raise exception 'Pet com id % não encontrado.', p_id;
    end if;

    if exists (select 1 from pets where id = p_id and cliente_id = c_id) then 
        raise exception 'O cliente % já é dono do pet %.', c_id, p_id;
    end if;

    update pets
    set cliente_id = c_id
    where id = p_id;

    raise notice 'Pet % alterado com sucesso', p_id;
end;
$$;

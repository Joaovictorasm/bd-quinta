--01

create or replace function impedir_cancelamento_agendamento()
returns trigger
language plpgsql
as $$
begin
    if old.status = 'concluido' and new.status = 'cancelado' then
        raise exception 'Não é possível cancelar um agendamento que já foi concluído!';
    end if;
    
    return new;
$$;

create trigger trg_impedir_cancelamento
before update on agendamentos
for each row
execute function impedir_cancelamento_agendamento();
--02
create or replace function log_transferencia_cliente_pet()
returns trigger
language plpgsql
as $$
begin
    if old.cliente_id is distinct from new.cliente_id then
        insert into log_transferencias_pets (pet_id, cliente_anterior, cliente_novo, data_transferencia)
        values (new.id, old.cliente_id, new.cliente_id, current_timestamp);
    end if;
    
    return new;
end;
$$;

create trigger trg_log_transferencia_pet
after update on pets
for each row
execute function log_transferencia_cliente_pet();

--03

create or replace function log_exclusao_produto()
returns trigger
language plpgsql
as $$
begin
    insert into log_produtos_deletados (produto_id, nome, preco)
    values (old.id, old.nome, old.preco);
    
    return old;
end;
$$;

create trigger trg_log_exclusao_produto
after delete on produtos
for each row
execute function log_exclusao_produto();

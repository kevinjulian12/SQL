-- Ejercicio SQL

-- artists (artistid,name,musicstyleid)
-- albums (albumid,name,year,artistid)

-- 1) Listar todos los artistas.

select *
from sandbox.artists ar;


-- 2) Listar los artistas cuyos nombres comienzan con 'L'.

select *
from sandbox.artists ar
where ar.name LIKE 'L%';

-- 3) Listar los albums del artista 'Dos minutos'.

select al.*
from sandbox.albums al
inner join sandbox.artists ar
on al.artistid = ar.artistid
where ar.name = 'Dos minutos';


-- 4) Listar los artistas que sacaron un album en el 2010.

select ar.*
from sandbox.albums al
inner join sandbox.artists ar
on al.artistid = ar.artistid
where al.year = '2010';

-- 5) Listar los artistas que tienen nombres que comienzan con 'G' o que sacaron un album en el 2005.

select ar.*
from sandbox.albums al
inner join sandbox.artists ar
on al.artistid = ar.artistid
where al.year = '2005' OR ar.name LIKE 'G%';

-- 6) Listar los albums que no tienen un artista asociado.
/**/
select *
from sandbox.albums al
left join sandbox.artists ar
on ar.artistid = al.artistid
where ar.artistid is null
order by al.name


-- 7) Listar los albums de los artistas 'Shakira, Madonna, Los Chalchaleros y Gardel'. 

select al.*
from sandbox.albums al
inner join sandbox.artists ar
on ar.artistid = al.artistid
where ar.name LIKE '%Shakira%' 
OR ar.name LIKE '%Madonna%'
OR ar.name LIKE '%Los Chalchaleros%'
OR ar.name LIKE '%Gardel%';

-- 8) Listar la cantidad de albums que tiene cada artista.

select ar.name,count(al.artistid) as cantidadAlbum
from sandbox.albums al
inner join sandbox.artists ar
on ar.artistid = al.artistid
group by ar.name
order by ar.name


-- 9) Listar los artistas que no tienen albums.
/**/
select ar.name
from sandbox.artists ar
left join sandbox.albums al
on ar.artistid = al.artistid
where al.albumid is null
order by ar.name


-- 10) Listar los artistas que tienen más de 1 album. (Usar Group by y having).

select ar.name,count(al.artistid) as cantidadAlbum
from sandbox.albums al
inner join sandbox.artists ar
on ar.artistid = al.artistid
group by ar.name
having count(al.artistid) > 1
order by ar.name
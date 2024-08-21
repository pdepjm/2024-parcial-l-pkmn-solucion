% Primera Parte: Pokédex

% Explorando el mundo de Pokémon vamos conociendo pokemones y recopilando información en nuestra pokédex:

% Pokemon: De estos conocemos sus tipos:
% - Pikachu es de tipo Eléctrico
% - Charizard es de tipo Fuego
% - Venusaur es de tipo Planta
% - Blastoise y Totodile son de tipo Agua
% - Snorlax es de tipo Normal
% - Rayquaza es de tipo Dragón y de tipo Volador
% - De Arceus no se conoce su tipo

% Entrenadores: En el camino nos encontramos con otros entrenadores. De estos conocemos que pokemones tienen:
% - Ash, tiene un Pikachu y un Charizard.
% - Brock, tiene un Snorlax.
% - Misty, tiene un Blastoise, Venusaur y un Arceus

% 1) Saber si un pokémon es de tipo múltiple, esto ocurre cuando tiene más de un tipo.
% 2) Saber si un pokemon es legendario, lo cual ocurre si es de tipo múltiple y ningún entrenador lo tiene.
% 3) Saber si un pokemon es misterioso, lo cual ocurre si es el único en su tipo o ningún entrenador lo tiene. 

% Hechos: pokemon(Pokemon, Tipo)
pokemon(pikachu, electrico).
pokemon(charizard, fuego).
pokemon(venusuar, planta).
pokemon(blastoise, agua).
pokemon(snorlax, normal).
pokemon(rayquaza, dragon).
pokemon(rayquaza, volador).

% Hechos: tieneA(Entrenador, Pokemon)
tieneA(ash, pikachu).
tieneA(brock, snorlax).
tieneA(misty, blastoise).
tieneA(misty, venusuar).
tieneA(misty, arceus).

% Punto 1:
esDeMultipleTipo(Pokemon) :-
    pokemon(Pokemon, UnTipo),
    pokemon(Pokemon, OtroTipo),
    UnTipo \= OtroTipo.

% Punto 2:
esLegendario(Pokemon) :-
    esDeMultipleTipo(Pokemon),
    nadieLoTiene(Pokemon).

% Punto 3:
esMisterioso(Pokemon) :-
    esUnicoONingunEntrenadorLotiene(Pokemon).

esUnicoONingunEntrenadorLotiene(Pokemon) :-
    esUnico(Pokemon).

esUnicoONingunEntrenadorLotiene(Pokemon) :-
    nadieLoTiene(Pokemon).

% Predicados Auxiliares: 
esUnico(Pokemon) :-
    pokemon(Pokemon, Tipo),
    not((pokemon(OtroPokemon, Tipo), OtroPokemon \= Pokemon)).

nadieLoTiene(Pokemon) :-
    esPokemon(Pokemon),
    not(tieneA(_, Pokemon)).

esPokemon(Pokemon) :-
    pokemon(Pokemon, _).

esPokemon(Pokemon) :-
    tieneA(_, Pokemon).

% Segunda Parte: Movimientos

% Mientras exploramos el mundo Pokémon vemos que los pokemones hacen movimientos e iremos recopilando en nuestra pokédex:

% Movimientos: Hasta ahora conocemos las siguientes clases de movimientos:
% - Físicos: Son de una determinada potencia.
% - Especiales: Además de tener una potencia, son de un determinado tipo.
% - Defensivos: Reducen el daño recibido. Tienen un porcentaje de reducción.

% Ejemplos de algunos movimientos que pueden usar los pokemones:
% - Pikachu puede usar Mordedura (movimiento físico con 95 de potencia) e 
%   Impactrueno (movimiento especial de tipo Eléctrico con 40 de potencia). 
% - Charizard puede usar Garra Dragón (movimiento especial de tipo Dragón con 100 de potencia) y 
%   también puede usar Mordedura.
% - Blastoise puede usar Protección (movimiento defensivo que reduce el daño de ataques un 10%) y 
%   Placaje (movimiento físico con 50 de potencia)
% - Arceus puede usar Impactrueno, Garra Dragón, Protección, Placaje 
%   y Alivio (movimiento defensivo que reduce el daño de ataques un 100%).
% - Snorlax no puede usar ningún movimiento.

% Modelar en Prolog la información recopilada hasta ahora y modelar lo necesario para poder consultar:

% El daño de ataque de un movimiento, lo cual se calcula de la siguiente forma:
% - En los movimientos físicos, es su potencia
% - En los movimientos defensivos es 0
% - En los movimientos especiales está dado por su potencia multiplicado por:
%   - 1.5 si es un tipo básico (fuego, agua, planta o normal)
%   - 3 si es de tipo Dragón
%   - 1 en cualquier otro caso

% 1) La capacidad ofensiva de un pokémon, la cual está dada por la sumatoria de los
% daños de ataque de los movimientos que puede usar.
% 2) Si un entrenador es picante, lo cual ocurre si todos sus pokemons tienen una capacidad ofensiva
% total superior a 200 o son misteriosos.

% Hechos: puedeUsar(Pokemon, NombreMov)
puedeUsar(pikachu, mordedura).
puedeUsar(pikachu, impactrueno).

puedeUsar(charizard, garraDragon).
puedeUsar(charizard, mordedura).

puedeUsar(blastoise, proteccion).
puedeUsar(blastoise, placaje).

puedeUsar(arceus, impactrueno).
puedeUsar(arceus, placaje).
puedeUsar(arceus, proteccion).
puedeUsar(arceus, garraDragon).

% Movimiento: movimiento(NombreMov, Categoria)
movimiento(mordedura, tipoFisico(95)).
movimiento(impactrueno, tipoEspecial(electrico, 40)).
movimiento(garraDragon, tipoEspecial(dragon, 100)).
movimiento(proteccion, tipoDefensivo(-0.10)).
movimiento(placaje, tipoFisico(50)).
movimiento(alivio, tipoDefensivo(1)).

% Punto 1:
capacidadOfensiva(Pokemon, Ofensiva) :-
    findall(PotenciaDeAtaque, potenciaDeAtaqueDeUnMovDe(Pokemon, _, PotenciaDeAtaque), ListaDeAtaques),
    length(ListaDeAtaques, Ofensiva).

potenciaDeAtaqueDeUnMovDe(Pokemon, Movimiento, PotenciaDeAtaque) :-
    puedeUsar(Pokemon, Movimiento),
    movimiento(Movimiento, TipoDeMov),
    potenciaDeAtaqueDelTipoDelMov(TipoDeMov, PotenciaDeAtaque).

potenciaDeAtaqueDelTipoDelMov(tipoFisico(PotenciaDeAtaque), PotenciaDeAtaque).
potenciaDeAtaqueDelTipoDelMov(tipoDefensivo(_), 0).

potenciaDeAtaque(tipoEspecial(Tipo, PotenciaAtaqueBase), PotenciaAtacante) :-
    multiplicadorPorTipo(Tipo, Multiplicador),
    PotenciaAtacante is PotenciaAtaqueBase * Multiplicador.

potenciaDeAtaque(tipoEspecial(Tipo, PotenciaAtacante), PotenciaAtacante) :-
    not(multiplicadorPorTipo(Tipo, _)).

multiplicadorPorTipo(dragon, 3).
multiplicadorPorTipo(fuego, 1.5).
multiplicadorPorTipo(agua, 1.5).
multiplicadorPorTipo(planta, 1.5).
multiplicadorPorTipo(normal, 1.5).

% Punto 2:
esPicante(Entrenador) :-
    tieneA(Entrenador, _),
    forall(tieneA(Entrenador, Pokemon), tieneUnaCapacidadOfensivaSupOEsMisterioso(Pokemon)).

tieneUnaCapacidadOfensivaSupOEsMisterioso(Pokemon) :-
    esMisterioso(Pokemon).

tieneUnaCapacidadOfensivaSupOEsMisterioso(Pokemon) :-
    tieneUnaCapacidadOfensivaSup(Pokemon).

tieneUnaCapacidadOfensivaSup(Pokemon) :-
    potenciaDeAtaqueDeUnMovDe(Pokemon, _, PotenciaDeAtaque),
    PotenciaAtacante > 200.

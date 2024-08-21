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
tipo(pikachu, electrico).
tipo(charizard, fuego).
tipo(venusuar, planta).
tipo(blastoise, agua).
tipo(snorlax, normal).
tipo(rayquaza, dragon).
tipo(rayquaza, volador).

% Hechos: tieneA(Entrenador, Pokemon)
tieneA(ash, pikachu).
tieneA(brock, snorlax).
tieneA(misty, blastoise).
tieneA(misty, venusuar).
tieneA(misty, arceus).

pokemon(Pokemon):-
	tipo(Pokemon,_).

pokemon(Pokemon):-
	tieneA(_, Pokemon).

% Punto 1:
esDeMultipleTipo(Pokemon) :-
    tipo(Pokemon, UnTipo),
    tipo(Pokemon, OtroTipo),
    UnTipo \= OtroTipo.

% Punto 2:
esLegendario(Pokemon) :-
    esDeMultipleTipo(Pokemon),
    nadieLoTiene(Pokemon).

% Punto 3:

esMisterioso(Pokemon) :-
    esUnico(Pokemon).

esMisterioso(Pokemon) :-
    nadieLoTiene(Pokemon).

% Predicados Auxiliares: 
esUnico(Pokemon) :-
    tipo(Pokemon, Tipo),
    not((tipo(OtroPokemon, Tipo), OtroPokemon \= Pokemon)).

nadieLoTiene(Pokemon) :-
    pokemon(Pokemon),
    not(tieneA(_, Pokemon)).

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

% 1) El daño de ataque de un movimiento, lo cual se calcula de la siguiente forma:
% - En los movimientos físicos, es su potencia
% - En los movimientos defensivos es 0
% - En los movimientos especiales está dado por su potencia multiplicado por:
%   - 1.5 si es un tipo básico (fuego, agua, planta o normal)
%   - 3 si es de tipo Dragón
%   - 1 en cualquier otro caso

% 2) La capacidad ofensiva de un pokémon, la cual está dada por la sumatoria de los
% daños de ataque de los movimientos que puede usar.
% 3) Si un entrenador es picante, lo cual ocurre si todos sus pokemons tienen una capacidad ofensiva
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

% Movimiento: movimiento(NombreMov, Clase)
movimiento(mordedura, fisico(95)).
movimiento(impactrueno, especial(electrico, 40)).
movimiento(garraDragon, elpecial(dragon, 100)).
movimiento(proteccion, defensivo(10)).
movimiento(placaje, fisico(50)).
movimiento(alivio, defensivo(100)).

% Punto 1:

danio(Movimiento, Danio):-
    movimiento(Movimiento, Clase), 
    danioPorClase(Clase, Danio).

danioPorClase(fisico(Potencia), Potencia). 
danioPorClase(defensivo(_), 0). 
danioPorClase(especial(Tipo, Potencia), Danio):-
    coeficienteSegun(Tipo, Coeficiente), 
    Danio is Potencia * Coeficiente.

coeficienteSegun(dragon, 3).
coeficienteSegun(Tipo, 1.5):-
    esBasico(Tipo).

coeficienteSegun(Tipo, 1):-
    Tipo \= dragon, 
    not(esBasico(Tipo)).

esBasico(agua).
esBasico(fuego).
esBasico(planta).
esBasico(normal).

% Punto 2

capacidadOfensiva(Pokemon, Capacidad) :-
    pokemon(Pokemon),
    findall(Danio, danioDe(Pokemon, Danio), Danios),
    length(Danios, Capacidad).

danioDe(Pokemon, Danio) :-
    puedeUsar(Pokemon, Movimiento),
    danio(Movimiento, Danio).

% Punto 3:
esPicante(Entrenador) :-
    tieneA(Entrenador, _),
    forall(tieneA(Entrenador, Pokemon), cumplePicantez(Pokemon)).

cumplePicantez(Pokemon) :-
    esMisterioso(Pokemon).

cumplePicantez(Pokemon) :-
    capacidadOfensiva(Pokemon, Capacidad),
    Capacidad > 200.

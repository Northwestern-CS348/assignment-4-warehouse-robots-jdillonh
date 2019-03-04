(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)) )
   )
   
   (:action robotMove 
        :parameters (?start - location ?end - location ?rob - robot)
        :precondition (and (at ?rob ?start) (no-robot ?end)
                       (connected ?start ?end))
        :effect (and (not (no-robot ?end)) (no-robot ?start) (at ?rob ?end))
                 
   )
   (:action robotMoveWithPallette 
        :parameters (?start - location ?end - location ?rob - robot ?pal - pallette)
        :precondition (and (at ?rob ?start) (at ?pal ?start) 
                      (no-robot ?end) (no-pallette ?end)
                      (connected ?start ?end) )
        :effect (and (not (no-pallette ?end)) (not (no-robot ?end)) 
                (no-robot ?start) (no-pallette ?start)
                 (at ?rob ?end) (at ?pal ?end))
   )
   
   (:action moveItemFromPalletteToShipment 
        :parameters (?loc - location ?ship - shipment ?order - order ?si - saleitem ?pal - pallette)
        :precondition (and (packing-location ?loc) (ships ?ship ?order) (orders ?order ?si)
                        (contains ?pal ?si) (at ?pal ?loc) (packing-at ?ship ?loc) )
        :effect (and (not (contains ?pal ?si)) (includes ?ship ?si) )
   
   )
   
   (:action completeShipment 
        :parameters (?loc - location ?order - order ?ship - shipment)
        :precondition (and (started ?ship) (packing-at ?ship ?loc) (not (complete ?ship)))
        :effect (and (complete ?ship) (available ?loc))
   
   )

)






















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
    	(has ?r - robot ?p - pallette) ; redundant Don't use

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
        :precondition (and (unstarted ?s) 
                    (not (complete ?s)) 
                    (ships ?s ?o) (available ?l) (packing-location ?l))
                    
        :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) 
                (not (available ?l)))
   )
   
   ;; My Code Here:
   (:action robotMove
        :parameters (?start - location ?end - location ?rob - robot)
        :precondition (and (no-robot ?end) (at ?rob ?start) (connected ?start ?end))
        :effect (and (not (no-robot ?end)) (no-robot ?start) (at ?rob ?end))
                 
    )
   
   (:action robotMoveWithPallette
        :parameters (?start - location ?end - location
                     ?rob - robot ?pal - pallette)
        :precondition (and (connected ?start ?end) (no-pallette ?end) (no-robot ?end) (at ?rob ?start) (at ?pal ?start)) ;; [at ?pal ?start] do palletes have locations?
`            
        :effect (and (not (no-robot ?end)) (not (at ?rob ?start)) (not (at ?pal ?start)) 
                (no-robot ?start) (no-pallette ?start) (not (no-pallette ?end)) 
                (at ?rob ?end) (at ?pal ?end))
    )

   (:action moveItemFromPalletteToShipment
        :parameters (?loc - location ?ship - shipment ?pal - pallette 
                     ?si - saleitem ?order - order)
                     
        :precondition (and  (packing-at ?ship ?loc) (at ?pal ?loc) (contains ?pal ?si)      ; shipment already started from startShipment
                      (orders ?order ?si) (ships ?ship ?order) )
        
        :effect (and (not (unstarted ?ship)) (started ?ship) (not (contains ?pal ?si)) (includes ?ship ?si) )
   )
   
   (:action completeShipment
        :parameters (?ship - shipment ?order - order ?loc - location)
        
        :precondition (and (started ?ship) (not (complete ?ship)) 
                      (ships ?ship ?order) (packing-location ?loc) )
        
        :effect (and (complete ?ship) (not (packing-at ?ship ?loc)) (available ?loc)) 
    )

)






















#lang at-exp codespells



(define (_world-above  #:padding [padding 50] a b)
  ;TODO: Make this take numbers so we don't have to ~a everything
  @unreal-js{
     (function(){
       var as = [@(if (procedure? a) (a) a)].flat();
       var bs = [@(if (procedure? b) (b) b)].flat();

       var a_bounds = GameplayStatics.GetActorArrayBounds(as, false); 
       var b_bounds = GameplayStatics.GetActorArrayBounds(bs, false); 

       var a_to_move_Z = @(~a padding) + a_bounds.BoxExtent.Z / 2
       var b_to_move_Z = -@(~a padding) - b_bounds.BoxExtent.Z / 2

       as.map((a)=>{
         a.SetActorLocation({X: a.GetActorLocation().X, Y: a.GetActorLocation().Y, Z: a.GetActorLocation().Z + a_to_move_Z})
       })

       bs.map((b)=>{
         b.SetActorLocation({X: b.GetActorLocation().X, Y: b.GetActorLocation().Y, Z: b.GetActorLocation().Z +  b_to_move_Z})
       })
        
       return as.concat(bs)
     })()
   })

(define-classic-rune (world-above #:padding [padding 50] . as)
  #:background "green"
  #:foreground (above (circle 40 'solid 'green)
                      (circle 40 'solid 'green))

  (match (length as)
    [1 (first as)]
    [2 (_world-above #:padding padding (first as) (second as))]
    [else (_world-above
           (first as)
           (apply world-above (rest as)))]
    ))

(define-classic-rune-lang my-mod-lang
  (world-above))

(module+ main
  (codespells-workspace ;TODO: Change this to your local workspace if different
   (build-path (current-directory) ".." ".."))
  
  (once-upon-a-time
   #:world (demo-world)
   #:aether (demo-aether
             #:lang (my-mod-lang #:with-paren-runes? #t))))

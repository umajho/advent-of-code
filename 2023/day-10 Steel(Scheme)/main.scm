(define (read-lines)
  (define (read-line_ acc)
    (let ([l (read-line-from-port (stdin))])
      (if (equal? l 'eof)
        acc
        (read-line_ (cons l acc)))))
  (reverse (read-line_ (list))))

(define (char-index str ch)
  (define (reduce_ i)
    (if (= (+ i 1) (string-length str))
      'nil
      (if (string=? ch (substring str i (+ i 1)))
        i
        (reduce_ (+ i 1)))))
  (reduce_ 0))

(define (find-s maze)
  (define (reduce_ maze y)
    (let* ( ; ne estas eble ke `maze` estus malplena ĉi tie.
        [head (car maze)] [tail (cdr maze)]
        [x (char-index head "S")])
      (if (equal? x 'nil)
        (reduce_ tail (+ y 1))
        (list x y))))
  (reduce_ maze 0))

(define (div-2 x) (if (odd? x) (/ (- x 1) 2) (/ x 2)))

(define (lists-intersect a b)
  (let ([b-set (list->hashset b)])
    (filter (lambda (item) (hashset-contains? b-set item)) a)))

(define (hashsets-merge a b)
  (list->hashset (append (hashset->list a) (hashset->list b))))

(define (go coord dir)
    (let ([next-coord (cond
        [(equal? dir '⇦) (list (- (first coord) 1) (second coord))]
        [(equal? dir '⇨) (list (+ (first coord) 1) (second coord))]
        [(equal? dir '⇧) (list (first coord) (- (second coord) 1))]
        [(equal? dir '⇩) (list (first coord) (+ (second coord) 1))]
        [(equal? dir '⬀) (list (+ (first coord) 1) (- (second coord) 1))]
        [(equal? dir '⬂) (list (+ (first coord) 1) (+ (second coord) 1))]
        [(equal? dir '⬃) (list (- (first coord) 1) (+ (second coord) 1))]
        [(equal? dir '⬁) (list (- (first coord) 1) (- (second coord) 1))])])
      next-coord))

(define (maze-pipe-at maze x y)
  (define (maze-char-at maze x y)
    (if (= y 0)
      (substring (car maze) x (+ x 1))
      (maze-char-at (cdr maze) x (- y 1))))
  (let ([pipe-ch (maze-char-at maze x y)])
    (cond ; aĵoj kiel “`'║]`” kaŭzas erarojn de koda markado en VSCode.
      [ (string=? pipe-ch "|") '║ ] [ (string=? pipe-ch "-") '═ ]
      [ (string=? pipe-ch "L") '╚ ] [ (string=? pipe-ch "J") '╝ ]
      [ (string=? pipe-ch "7") '╗ ] [ (string=? pipe-ch "F") '╔ ]
      [ (string=? pipe-ch "S") 'fin ] [ #t 'nil ])))

(define (determine-dir pipe last-dir)
  (cond
    [(equal? pipe '║)
      (cond [ (equal? last-dir '⇧) '⇧ ] [ (equal? last-dir '⇩) '⇩ ] [#t 'nil])]
    [(equal? pipe '═)
      (cond [ (equal? last-dir '⇦) '⇦ ] [ (equal? last-dir '⇨) '⇨ ] [#t 'nil])]
    [(equal? pipe '╚)
      (cond [ (equal? last-dir '⇩) '⇨ ] [ (equal? last-dir '⇦) '⇧ ] [#t 'nil])]
    [(equal? pipe '╝)
      (cond [ (equal? last-dir '⇩) '⇦ ] [ (equal? last-dir '⇨) '⇧ ] [#t 'nil])]
    [(equal? pipe '╗)
      (cond [ (equal? last-dir '⇧) '⇦ ] [ (equal? last-dir '⇨) '⇩ ] [#t 'nil])]
    [(equal? pipe '╔)
      (cond [ (equal? last-dir '⇧) '⇨ ] [ (equal? last-dir '⇦) '⇩ ] [#t 'nil])]
    [(equal? pipe 'fin) 'fin]
    [#t 'nil]))

(define (can-go? width height x y)
  (and (>= x 0) (>= y 0) (< x width) (< y height)))

(define (walk maze width height coord last-dir is-part-2)
  (define (new-data-for-part-2) (list (hashset) 'nil (list 'nil 'nil 'nil)))
  (define (record-data-for-part-2 data coord fin?)
    (if (equal? data 'nil)
      'nil
      (let* (
          [trail (first data)]
          [top-coord (second data)]
          [first-last-start-coords (third data)]
          [first-coord (first first-last-start-coords)]
          [last-coord (second first-last-start-coords)]
          [start-coord (third first-last-start-coords)])
        (list
          (hashset-insert trail coord)
          (if (or (equal? top-coord 'nil) (< (second coord) (second top-coord)))
            coord
            top-coord)
          (list
            (if (equal? first-coord 'nil) coord first-coord)
            (if fin? last-coord coord)
            (if fin? coord 'nil))))))
  (define (reduce_ coord last-dir i data-for-part-2)
    (let* (
        [x (first coord)] [y (second coord)]
        [can-go? (can-go? width height x y)]
        [pipe (if can-go? (maze-pipe-at maze x y) 'nil)]
        [dir (determine-dir pipe last-dir)])
      (cond
        [(equal? dir 'nil) 'nil]
        [(equal? dir 'fin)
          (list (+ i 1) (record-data-for-part-2 data-for-part-2 coord #t))]
        [#t (let* ([next-coord (go coord dir)])
          (reduce_ next-coord dir (+ i 1)
            (record-data-for-part-2 data-for-part-2 coord #f)))])))
    (reduce_ coord last-dir 0 (if is-part-2 (new-data-for-part-2) 'nil)))

(define (walk-each maze width height s-coord dirs is-part-2)
  (define (reduce_ dirs)
    (let* (
        [head (car dirs)] [tail (cdr dirs)]
        [going (go s-coord head)]
        [result (walk maze width height going head is-part-2)])
      (if (equal? result 'nil) (reduce_ tail) result)))
  (reduce_ dirs))

(define (get-full-inner-dirs tangent-inner-dir)
  (let* ([dirs '(⇧ ⬀ ⇨ ⬂ ⇩ ⬃ ⇦ ⬁ ⇧)])
    (define (reduce_ dirs last)
      (let* ([head (car dirs)] [tail (cdr dirs)])
        (if (equal? head tangent-inner-dir)
          (list last tangent-inner-dir (car tail))
          (reduce_ tail head))))
    (reduce_ dirs '⬁)))

(define (determine-tangent-inner-dir pipe last-dir last-tangent-inner-dir)
  (define (get-pipe-possible-tangent-inner-dirs pipe)
    (cond
      [(equal? pipe '║) '(⇨ ⇦)]
      [(equal? pipe '═) '(⇧ ⇩)]
      [(or (equal? pipe '╚) (equal? pipe '╗)) '(⬀ ⬃)]
      [(or (equal? pipe '╝) (equal? pipe '╔)) '(⬁ ⬂)]))
  (define (determine-flip-dir last-dir)
    (cond
      [(or (equal? last-dir '⇦) (equal? last-dir '⇨)) 'v]
      [(or (equal? last-dir '⇧) (equal? last-dir '⇩)) 'h]))
  (define (flip flip-dir dir)
    (cond
      [(equal? flip-dir 'v)
        (cond
          [ (equal? dir '⬀) '⬁ ] [ (equal? dir '⬁) '⬀ ]
          [ (equal? dir '⬂) '⬃ ] [ (equal? dir '⬃) '⬂ ])]
      [(equal? flip-dir 'h)
        (cond
          [ (equal? dir '⬀) '⬂ ] [ (equal? dir '⬂) '⬀ ]
          [ (equal? dir '⬁) '⬃ ] [ (equal? dir '⬃) '⬁ ])]))
  (let* (
      [possible-tangent-inner-dirs (get-pipe-possible-tangent-inner-dirs pipe)]
      [intersection (lists-intersect
        (list last-tangent-inner-dir) possible-tangent-inner-dirs)])
    (cond
      [(not (empty? intersection)) (car intersection)]
      [#t (let* (
          [last-inner-dirs (get-full-inner-dirs last-tangent-inner-dir)]
          [intersection (lists-intersect
            last-inner-dirs possible-tangent-inner-dirs)])
        (cond
          [(not (empty? intersection)) (car intersection)]
          [#t (flip (determine-flip-dir last-dir) last-tangent-inner-dir)]))])))

(define (gather-inner-edge-points
    maze init-coord init-dir init-tangent-inner-dir s-pipe walls)
  (define (maze-real-pipe-at x y)
    (if (hashset-contains? walls (list x y))
      (maze-pipe-at maze x y)
      'nil))
  (define (update-edge-points edge-points coord tangent-inner-dir)
    (reduce
      (lambda (dir acc)
        (let* (
            [edge-coord (go coord dir)]
            [pipe (maze-real-pipe-at (first edge-coord) (second edge-coord))])
          (if (equal? 'nil pipe) (hashset-insert acc edge-coord) acc)))
      edge-points (get-full-inner-dirs tangent-inner-dir)))
  (define (reduce_ coord last-dir last-tangent-inner-dir edge-points)
    (let* (
        [x (first coord)] [y (second coord)]
        [pipe (let ([pipe (maze-real-pipe-at x y)])
          (if (equal? pipe 'fin) s-pipe pipe))]
        [dir (determine-dir pipe last-dir)]
        [tangent-inner-dir
          (determine-tangent-inner-dir pipe last-dir last-tangent-inner-dir)]
        [new-edge-points (update-edge-points edge-points coord tangent-inner-dir)])
      (cond
        [(equal? coord init-coord) new-edge-points]
        [#t (let* ([next-coord (go coord dir)])
          (reduce_ next-coord dir tangent-inner-dir new-edge-points))])))
  (reduce_ (go init-coord init-dir) init-dir init-tangent-inner-dir (hashset)))

(define (gather-inner-points edge-points walls)
  (define (explore-around points-explored points-to-explore coord)
    (reduce
      (lambda (dir acc)
        (let ([new-coord (go coord dir)])
          (if (hashset-contains? points-explored new-coord) ; `points-explored` estas sufiĉa.
            acc
            (list
              (hashset-insert (first acc) new-coord)
              (cons new-coord (second acc))))))
      (list points-explored points-to-explore) '(⇦ ⇨ ⇧ ⇩)))
  (define (reduce_ points-explored points-to-explore)
    (if (empty? points-to-explore)
      (filter
        (lambda (coord) (not (hashset-contains? walls coord)))
        (hashset->list points-explored))
      (let* (
          [head (car points-to-explore)] [tail (cdr points-to-explore)]
          [result (explore-around points-explored tail head)])
        (reduce_ (first result) (second result)))))
  (reduce_ (hashsets-merge edge-points walls) (hashset->list edge-points)))

(let* (
    [is-part-2 (Ok? (maybe-get-env-var "PART_2"))]
    [maze (read-lines)]
    [width (string-length (car maze))] ; la exzisto de "\n" ne gravas.
    [height (length maze)]
    [s-coord (find-s maze)]
    [result (walk-each maze width height s-coord '(⇧ ⇨ ⇩) is-part-2)]
    [steps (div-2 (first result))]
    [data-for-part-2 (second result)])
  (if (not is-part-2)
    (displayln steps)
    (begin
      (define (get-top-pipe-init-dir pipe)
        (cond
          [ (or (equal? pipe '═) (equal? pipe '╔)) '⇨ ]
          [ (equal? pipe '╗) '⇩ ]))
      (define (get-top-pipe-tangent-inner-dir pipe)
        (cond ; ne eblas, ke ĉi tiu `pipe` estas `S`.
          [ (equal? pipe '═) '⇩ ]
          [ (equal? pipe '╗) '⬃ ]
          [ (equal? pipe '╔) '⬂ ]))
      (define (determine-s-pipe first-last-start-coords)
        (define (coord-minus a b)
          (list (- (first a) (first b)) (- (second a) (second b))))
        (let* (
            [first-coord (first first-last-start-coords)]
            [last-coord (second first-last-start-coords)]
            [start-coord (third first-last-start-coords)]
            [first-coord-from-start (coord-minus first-coord start-coord)]
            [last-coord-from-start (coord-minus last-coord start-coord)]
            [first-last-coords-from-start
              (list first-coord-from-start last-coord-from-start)])
          (cond
            [ (equal? (list '(0 -1) '(1 0))   first-last-coords-from-start) '╚ ]
            [ (equal? (list '(0 -1) '(0 1))   first-last-coords-from-start) '║ ]
            [ (equal? (list '(0 -1) '(-1 0))  first-last-coords-from-start) '╝ ]
            [ (equal? (list '(1 0)  '(0 1))   first-last-coords-from-start) '╔ ]
            [ (equal? (list '(1 0)  '(-1 0))  first-last-coords-from-start) '═ ]
            [ (equal? (list '(0 1)  '(-1 0))  first-last-coords-from-start) '╗ ])))
      (let* (
          [trail (first data-for-part-2)]
          [top-coord (second data-for-part-2)]
          [first-last-start-coords (third data-for-part-2)]
          [s-pipe (determine-s-pipe first-last-start-coords)]
          [top-pipe (maze-pipe-at maze (first top-coord) (second top-coord))]
          [init-dir (get-top-pipe-init-dir top-pipe)]
          [init-tangent-inner-dir (get-top-pipe-tangent-inner-dir top-pipe)]
          [edge-points (gather-inner-edge-points
              maze top-coord init-dir init-tangent-inner-dir s-pipe trail)]
          [inner-points (gather-inner-points edge-points trail)])
        (displayln (length inner-points))))))

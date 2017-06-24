(ns quil-try.core
  (:require [quil.core :as q]
            [quil.middleware :as m]))

(defn setup []
  ; Set frame rate to 30 frames per second.
  (q/frame-rate 30)
  ; Set color mode to HSB (HSV) instead of default RGB.
  (q/color-mode :hsb)
  ; setup function returns initial state. It contains
  ; circle color and position.
  {:color 0
   :rect-color 0
   :angle 0})

(defn update-state [state]
  ; Update sketch state by changing circle color and position.
  {:color (mod (+ (:color state) 0.7) 255)
   :rect-color (mod (+ (:rect-color state) 0.07) 255)
   :angle (+ (:angle state) 0.1)})

(defn draw-state [state]
  ; Clear the sketch by filling it with light-grey color.
  ; (q/background 240)
  ;(q/fill 127 255 127 10)
  (q/fill (:rect-color state) 255 255 10)
  (q/rect 0 0 (q/width) (q/height))
  ;(if (= (rem (q/frame-count) 100) 0)
  ;  (q/rect 0 0 (q/width) (q/height)))
          
  ; Calculate x and y coordinates of the circle.
  (let [angle (:angle state)
        x (* 150 (q/cos angle))
        y (* 150 (q/sin angle))]
    (dotimes [n 3]
      ; Move origin point to the center of the sketch.
      (q/with-translation [(* (+ n 1) (/ (q/width) 4))
                           (/ (q/height) 2)]
        ; Set circle color.
        (q/fill (mod (+ (:color state) (* n 40.0))255) 255 255)
        ; Draw the circle.
        (q/ellipse x y 100 100)))))

(q/defsketch quil-try
  :title "You spin my circle right round"
  :size [1920 1080]
  ; setup function called only once, during sketch initialization.
  :setup setup
  ; update-state is called on each iteration before draw-state.
  :update update-state
  :draw draw-state
  :features [:keep-on-top]
  ; This sketch uses functional-mode middleware.
  ; Check quil wiki for more info about middlewares and particularly
  ; fun-mode.
  :middleware [m/fun-mode])

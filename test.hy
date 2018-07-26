(import [http.server [HTTPServer SimpleHTTPRequestHandler BaseHTTPRequestHandler]]
        [urllib.parse [urlparse]]
        json)
(import senti_analysis)

(defclass EchoHandler [BaseHTTPRequestHandler]
  (defn do_GET [self]
    (setv content-len (int (.get self.headers "content-length")))
    (setv request-body (-> (.read self.rfile content-len)
                          (.decode "UTF-8")))
    (print request-body)
    (setv json-data (.loads json request-body))
    (print json-data)
    (print (. json-data ["type"]))
    (print (. json-data ["params"]))
    (.send_response self 200)
    (.send_header self "Content-type" "application/json")
    (.end_headers self)
    (setv response-body {"status" 400
                         "params" "不適切なパラメータです"})
    (when (= "senti-analysis" (. json-data ["type"]))
      (setv response-body
            {"status" 200
             "params" (senti_analysis.get-senti (. json-data ["params"]))}))
    (.wfile.write self (.encode (.dumps json response-body) "utf-8"))))

(setv httpd (HTTPServer (, "localhost" 8887) EchoHandler))

(.serve_forever httpd)

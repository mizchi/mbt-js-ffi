///| Fetch API Response
pub type Response @js.Value

///| js: response.json()
extern "js" fn Response::js_json(v : Response) -> @js.Promise =
  #| (v) => v.json()

///| js: response.text()
extern "js" fn Response::js_text(v : Response) -> @js.Promise =
  #| (v) => v.text()

///| js: response.status
extern "js" fn Response::js_status(v : Response) -> @js.Value =
  #| (v) => v.status

///| js: response.status
extern "js" fn Response::js_ok(v : Response) -> @js.Value =
  #| (v) => v.ok

///| js: response.status
extern "js" fn Response::js_body_used(v : Response) -> @js.Value =
  #| (v) => v.bodyUsed

///| response.status
pub fn Response::status(v : Response) -> Int {
  v.js_status().cast()
}

///| response.bodyUsed
pub fn Response::body_used(v : Response) -> Bool {
  v.js_body_used().cast()
}

///| response.ok
pub fn Response::ok(v : Response) -> Bool {
  v.js_status().cast()
}

///| resposne.json()
pub fn Response::json(v : Response) -> @js.Value!Error + Async {
  v.js_json().wait!()
}

///| response.text()
pub fn Response::text(v : Response) -> String!Error + Async {
  v.js_text().wait!().cast()
}

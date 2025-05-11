///|
pub type Request @js.Value

///|
extern "js" fn Request::js_new_request(
  url : String,
  init : @js.Value
) -> @js.Value =
  #| (url, init) => new Request(url, init)

///|
extern "js" fn Request::js_request_clone(self : Request) -> @js.Value =
  #| (self) => self.clone()

///|
extern "js" fn Request::js_request_headers_get(
  self : Request,
  key : String
) -> @js.Value =
  #| (self, key) => self.headers.get(key)

///|
fn build_request_init(
  http_method~ : String,
  headers~ : Map[String, String],
  body~ : Json?
) -> @js.Value {
  let init = @js.Object::new()
  init["method"] = http_method
  if body is Some(v) {
    init["body"] = @json.stringify(v)
  }
  if not(headers.is_empty()) {
    init["headers"] = @js.Object::from_iter(headers.iter()).to_value()
  }
  init.to_value()
}

///| new Request(url, init)
pub fn Request::new(
  url : String,
  http_method~ : String = "GET",
  headers~ : Map[String, String] = {},
  body~ : Json? = None
) -> Request {
  let init = build_request_init(http_method~, headers~, body~)
  Request::js_new_request(url, init).cast()
}

///| request.clone()
pub fn Request::clone(r : Request) -> Request {
  let cloned = r.js_request_clone()
  Request(cloned)
}

///| request.headers.get(key)
pub fn Request::get_header(r : Request, key : String) -> String? {
  let value = r.js_request_headers_get(key)
  if value.is_null() {
    None
  } else {
    Some(value.cast())
  }
}

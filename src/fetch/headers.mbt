///|
pub type Headers Map[String, String]

///|
pub fn Headers::new() -> Headers {
  Headers({})
}

///|
pub fn Headers::append(self : Headers, key : String, value : String) -> Unit {
  self._[key] = value
}

///|
pub fn Headers::to_js(self : Headers) -> @js.Value {
  @js.Object::from_iter(self._.iter()).to_value()
}

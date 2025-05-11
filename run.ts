import { request } from "./target/js/release/build/client/client.js";

const apiKey = Deno.env.get("ANTHROPIC_API_KEY")!;

// console.log("API Key:", apiKey);

try {
  await request(apiKey, "Hello world");
} catch (error) {
  console.error("Error:", error);
}

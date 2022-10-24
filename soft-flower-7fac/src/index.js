export default {
  async scheduled(event, env, ctx) {
    ctx.waitUntil(handleScheduled(event, env));
  },
};

async function handleScheduled(event, env) {
  console.log(env["TEST_VARIABLE"]);
  Date.prototype.toJSON = function () { return this.toLocaleString(); }
  console.log({ a: JSON.stringify(new Date()) });
  console.log(Math.floor(Date.now() / 1000))
}

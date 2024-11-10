import { Socket } from "phoenix"

export class CustomSocket extends Socket {
  // Adapted from https://github.com/phoenixframework/phoenix/tree/v1.7.14/assets/js/phoenix
  onConnClose = function (event) {
    let closeCode = event && event.code
    if (this.hasLogger()) this.log("transport", "close", event)

    // Extra closeCodes handling for Firefox
    // see https://github.com/phoenixframework/phoenix/pull/5735#issuecomment-2167196419
    if (closeCode == 1000 || closeCode == 1001) this.channels.forEach((c) => c.leave())

    this.triggerChanError()
    this.clearHeartbeats()
    if (!this.closeWasClean && closeCode !== 1000) {
      this.reconnectTimer.scheduleTimeout()
    }
    this.stateChangeCallbacks.close.forEach(([, callback]) => callback(event))
  }
}

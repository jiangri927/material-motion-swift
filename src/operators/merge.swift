/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import IndefiniteObservable

extension MotionObservableConvertible {

  /**
   Emits values as it receives them, both from upstream and from the provided stream.

   Does not emit state or core animation events from the provided stream.
   */
  public func merge(with stream: MotionObservable<T>) -> MotionObservable<T> {
    return MotionObservable<T> { observer in
      let upstreamSubscription = self.asStream().subscribe(next: observer.next,
                                                           state: observer.state,
                                                           coreAnimation: observer.coreAnimation)
      let subscription = stream.subscribe(next: observer.next, state: { _ in }, coreAnimation: { _ in })

      return {
        subscription.unsubscribe()
        upstreamSubscription.unsubscribe()
      }
    }
  }
}

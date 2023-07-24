/**
 * @description Tests TriggerHandler.cls
 * @group Tests
 */
@SuppressWarnings(
  'PMD.ApexUnitTestClassShouldHaveAsserts,PMD.MethodNamingConventions,PMD.EmptyCatchBlock'
)
@isTest
public class TriggerHandler_TEST {
  @isTest
  static void operations() {
    TriggerHandler handler = new TriggerHandler();

    TriggerHandler.TriggerHandlerException caughtException;
    try {
      handler.run();
    } catch (TriggerHandler.TriggerHandlerException e) {
      caughtException = e;
    }
    System.assertNotEquals(
      null,
      caughtException,
      'TriggerHandler.run should have thrown an exception if called outside of Trigger execution'
    );

    handler.testSetOperation = TriggerOperation.BEFORE_INSERT;
    handler.run();

    handler.testSetOperation = TriggerOperation.BEFORE_UPDATE;
    handler.run();

    handler.testSetOperation = TriggerOperation.BEFORE_DELETE;
    handler.run();

    handler.testSetOperation = TriggerOperation.AFTER_INSERT;
    handler.run();

    handler.testSetOperation = TriggerOperation.AFTER_UPDATE;
    handler.run();

    handler.testSetOperation = TriggerOperation.AFTER_DELETE;
    handler.run();

    handler.testSetOperation = TriggerOperation.AFTER_UNDELETE;
    handler.run();
  }

  @isTest
  static void maxLoopCount() {
    TriggerHandler handler = new TriggerHandler();
    handler.testSetOperation = TriggerOperation.AFTER_UPDATE;
    handler.setMaxLoopCount(2);
    handler.setMaxLoopCount(2); // setMaxLoopCount invoked twice for coverage
    handler.run();
    handler.run();
    TriggerHandler.TriggerHandlerException caughtException;
    try {
      handler.run();
    } catch (TriggerHandler.TriggerHandlerException e) {
      caughtException = e;
    }
    System.assertNotEquals(
      null,
      caughtException,
      'TriggerHandler.run should have thrown an exception if maxLoopCount is exceeded'
    );

    caughtException = null;
    handler.clearMaxLoopCount();
    try {
      handler.run();
    } catch (TriggerHandler.TriggerHandlerException e) {
      caughtException = e;
    }
    System.assertEquals(
      null,
      caughtException,
      'TriggerHandler.run should not have thrown an exception if clearMaxLoopCount() is called'
    );
  }

  @isTest
  static void loopCount() {
    TriggerHandler.LoopCount loopCount = new TriggerHandler.LoopCount();
    System.assertEquals(
      -1,
      loopCount.getMax(),
      'LoopCount.getMax() should default to -1'
    );
    System.assertEquals(
      0,
      loopCount.getCount(),
      'LoopCount.getCount() should default to 0'
    );
    loopCount.increment();
    System.assertEquals(
      1,
      loopCount.getCount(),
      'LoopCount.getCount() should return 1 after increment() is called'
    );
  }

  @isTest
  static void bypass() {
    TriggerHandler handler = new TriggerHandler();
    handler.testSetOperation = TriggerOperation.AFTER_UPDATE;
    handler.setMaxLoopCount(0);

    TriggerHandler.bypass('TriggerHandler'); // Bypasses itself

    TriggerHandler.TriggerHandlerException caughtException;
    try {
      handler.run(); // Will throw if trigger method invoked due to maxLoopCount of 0 (but expect it not to be invoked)
    } catch (TriggerHandler.TriggerHandlerException e) {
      caughtException = e;
    }
    System.assertEquals(
      null,
      caughtException,
      'TriggerHandler.run should have exited silently if bypassed'
    );
    System.assert(
      TriggerHandler.isBypassed('TriggerHandler'),
      'TriggerHandler.isBypassed should have returned true for bypassed handler'
    );
    TriggerHandler.clearBypass('TriggerHandler');
    System.assert(
      !TriggerHandler.isBypassed('TriggerHandler'),
      'TriggerHandler.isBypassed should have returned false after clearBypass is invoked'
    );
    TriggerHandler.bypass('TriggerHandler');
    TriggerHandler.clearAllBypasses();
    System.assert(
      !TriggerHandler.isBypassed('TriggerHandler'),
      'TriggerHandler.isBypassed should have returned false after clearAllBypasses is invoked'
    );
  }

  @isTest
  static void coverage() {
    TriggerHandler handler = new TriggerHandler();
    TriggerOperation operation = handler.operation;
  }
}

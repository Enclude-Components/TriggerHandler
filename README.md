# Trigger Handler

An opinionated trigger handler framework. Contains a single virtual class that can be extended to create a trigger handler without a lot of boilerplate code.

_Credit to https://github.com/trailheadapps_  
Originally by Kevin O'Hara github.com/kevinohara80/sfdc-trigger-framework

## Deploy

<a href="https://githubsfdeploy.herokuapp.com?owner=Enclude-Components&repo=TriggerHandler&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Usage Guide

### Extension Class

Create a class which extends the case Trigger Handler class

```java
public with sharing class AccountTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        // Code here will run when in the "Before Insert" Context
        System.debug('Overriding Before Insert Trigger...');

        // Records from the Trigger Context need to be cast to the correct SObject before using
        List<Account> triggerOld = (List<Account>) Trigger.old;
        List<Account> triggerNew = (List<Account>) Trigger.new;
        Map<Id, Account> triggerMapNew = (Map<Id, Account>) Trigger.newMap;
        Map<Id, Account> triggerMapOld = (Map<Id, Account>) Trigger.oldMap;
    }
}
```

#### Overridable Methods

- beforeInsert
- beforeUpdate
- beforeDelete
- afterInsert
- afterUpdate
- afterDelete
- afterUndelete

### Trigger

Only a single trigger should exist for each object. Not all operations need to be handled, but it can be useful to do so to prevent having to update the trigger.

```java
trigger AccountTrigger on Account(
   before insert,
   after insert,
   before update,
   after update,
   before delete,
   after delete,
   after undelete
) {
   //
   new AccountTriggerHandler().run();
}
```

### Max Loop Count

A Max Loop Count can be set to ensure that a trigger only runs once in the current transaction (though this should normally not be necessary)

```java
trigger Account on Account (after update) {
   AccountTriggerHandler handler = new AccountTriggerHandler();
   // Set the max number of executions
   handler.setMaxLoopCount(1);
   try {
      handler.run();
   } catch(TriggerHandler.TriggerHandlerException e) {
      // Exceeding the max loop count will throw an exception.
      System.debug(LoggingLevel.WARN, e.getMessage());
   }
}
```

### Bypassing a Trigger

Calling the `TriggerHandler.bypass` static method will ensure that the specified trigger does not run for the current transaction

```java
TriggerHandler.bypass('AccountTriggerHandler');
```

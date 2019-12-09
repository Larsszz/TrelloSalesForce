/**
 * Created by IlarionTokarskyi on 12/2/2019.
 */

public with sharing class WebHookDBHandler {
    private HttpResponse response;
    private List<Attachment__c> toInsertAtt;
    private List<Attachment__c> toDeleteAtt;

    public WebHookDBHandler(HttpResponse resp) {
        response = resp;
        startUpdateOrg();
    }

    private class Entity {
        String tag, entityName, path;
        private Entity(String tag, String entityName, String path) {
            this.tag = tag;
            this.entityName = entityName;
            this.path = path;
        }
    }

    private void startUpdateOrg() {
        List<Map<String, Object>> listMapsProperties = getListMapsProperties(response);
        List<Entity> entities = getEntities(listMapsProperties);
        if (entities.size() == 0) {
            return;
        }
        List<Entity> toInsert = new List<WebHookDBHandler.Entity>();
        List<Entity> toDelete = new List<WebHookDBHandler.Entity>();
        for(Entity entity: entities) {
            if(entity.tag == 'deleted') {
                toDelete.add(entity);
            } else if(entity.tag == 'file') {
                toInsert.add(entity);
            }
        }
        toDeleteAtt = getAttachmentsByEntities(toDelete);
        if (toDeleteAtt.size()>0) {
            delete toDeleteAtt;
        }
        toInsertAtt = createAttachmentsByEntities(toInsert);
        if (toInsertAtt.size()>0) {
            insert toInsertAtt;
        }
    }

    private List<Map<String, Object>> getListMapsProperties(HttpResponse resp) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        List<Map<String, Object>> listMapsProperties = new List<Map<String, Object>>();
        List<Object> entries = (List<Object>) responseMap.get('entries');
        for (Object obj : entries) {
            listMapsProperties.add((Map<String, Object>) obj);
        }
        return listMapsProperties;
    }

    private List<Entity> getEntities(List<Map<String, Object>> listMapsProperties) {
        List<Entity> entities = new List<WebHookDBHandler.Entity>();
        for (Map<String, Object> property : listMapsProperties) {
            entities.add(new Entity((String) property.get('.tag'), (String) property.get('name'), (String) property.get('path_display')));
        }
        return entities;
    }

    private List<Attachment__c> getAttachmentsByEntities(List<Entity> entities) {
        List<String> links = new List<String>();
        for (Entity entity: entities) {
            links.add(entity.path);
        }
        return SelectUtility.getAttachmentsByLinks(links);
    }

    private List<Attachment__c> createAttachmentsByEntities(List<Entity> entities) {
        List<Attachment__c> result = new List<Attachment__c>();
        for(Entity entity: entities) {
            result.add(new Attachment__c(Name = entity.entityName, Link__c = entity.path, TaskBoard__c = getTaskIdFromEntity(entity)));
        }
        return result;
    }

    private String getTaskIdFromEntity(Entity entity) {
        String[] arrayStrings = entity.path.split('/');
        return arrayStrings[1];
    }
}
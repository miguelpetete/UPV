import json
import random
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from pygomas.bditroop import BDITroop
from pygomas.bdifieldop import BDIFieldOp
from agentspeak import Actions
from agentspeak import grounded
from agentspeak.stdlib import actions as asp_action
from pygomas.ontology import DESTINATION

from pygomas.agent import LONG_RECEIVE_WAIT

class BDISoldier1(BDITroop):
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)                

        @actions.add_function(".friendsAlive",())
        def _friendsAlive():
            return self.soldiers_count

        @actions.add_function(".patrulla1", (tuple))
        def _patrulla1(puntoBandera):        
            x_bandera = puntoBandera[0]
            y_bandera = puntoBandera[2]
            puntosX = [x_bandera+40, x_bandera-40, y_bandera+40, y_bandera-40]
            while true:
                if(self.map.can_walk(puntos[0], puntos[2])):
                      self.movement.destination.x = puntos[0]
                      self.movement.destination.z = puntos[2]
                      wait(1000)
                if(self.map.can_walk(puntos[0], puntos[3])):
                      self.movement.destination.x = puntos[0]
                      self.movement.destination.z = puntos[3]
                      wait(1000)
                if(self.map.can_walk(puntos[1], puntos[2])):
                      self.movement.destination.x = puntos[1]
                      self.movement.destination.z = puntos[2]
                      wait(1000)
                if(self.map.can_walk(puntos[1], puntos[3])):
                      self.movement.destination.x = puntos[1]
                      self.movement.destination.z = puntos[3]   
                      wait(1000)         
            yield

        @action.add_function(".menorVida",(tuple, tuple, ))
        def _menorVida(vida, agentes):
            posMenor = 0
            for valor in len(vida):
                if vida[valor] < vida[posMenor]:
                    posMenor = valor 
                    
            return agentes[posMenor]
            
class BDISoldier2(BDITroop):
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)                

        @actions.add_function(".friendsAlive",())
        def _friendsAlive():
            return self.soldiers_count

        @actions.add_function(".patrulla2", (tuple))
        def _patrulla1(puntoBandera):        
            x_bandera = puntoBandera[0]
            y_bandera = puntoBandera[2]
            puntosX = [x_bandera+20, x_bandera-20, y_bandera+20, y_bandera-20]
            while true:
                if(self.map.can_walk(puntos[0], puntos[2])):
                      self.movement.destination.x = puntos[0]
                      self.movement.destination.z = puntos[2]
                      wait(1000)
                if(self.map.can_walk(puntos[0], puntos[3])):
                      self.movement.destination.x = puntos[0]
                      self.movement.destination.z = puntos[3]
                      wait(1000)
                if(self.map.can_walk(puntos[1], puntos[2])):
                      self.movement.destination.x = puntos[1]
                      self.movement.destination.z = puntos[2]
                      wait(1000)
                if(self.map.can_walk(puntos[1], puntos[3])):
                      self.movement.destination.x = puntos[1]
                      self.movement.destination.z = puntos[3]   
                      wait(1000)         
            yield        
                    

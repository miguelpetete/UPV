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



"---------------------------------------PATRULLERO1---------------------------------------"

class BDIPatrullero1(BDITroop):
      
      def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
        @actions.add_function(".patrulla1", (tuple,))
        def _patrulla1(puntoBandera):
            "
            Estos agentes patrullarán la zona más lejana a la bandera
            "            
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
        
        @actions.add_function(".patrulla2",(tuple,))           
        def _patrulla2(puntoBandera):
            "
            Estos agentes patrullarán la zona más cercana a la bandera
            "            
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
            
        @actions.add_function(".friendsAlive",0)
        def _friendsAlive():
            return self.team_count
            
        @actions.add_function(".medicsAlive",0)
        def _medicsAlive():
            return self.medics_count
            
        @actions.add_function(".opsAlive",0)
        def _opsAlive():
            return self.fieldops_count
            
        @actions.add_function(".soldiersAlive",0)
        def _medicsAlive():
            return self.soldiers_count
                  
        @actions.add(".banderaRobada", 0)
        "
        En caso de ser robada la bandera, el soldado se va rápidamente a la base enemiga, ya que es muy probable que por el camino encuentre al enemigo que lleva la bandera
        "  
        def _banderaRobada():
            self.movement.destination.x = self.map.allied_base.get_init_x() - self.map.allied_base.get_end_x()
            self.movement.destination.z = self.map.allied_base.get_init_z() - self.map.allied_base.get_end_z()
            yield
           
        @actions.add_function(".disPunto", (tuple, tuple,))
        "
        Calcula la distancia a la que se encuentra del enemigo en ese intante.
        "
        def _disEnemigo(punto, puntoPropio):
           
            x = punto[0]
            y= punto[2]
            
           x_propio = puntoPropio[0]
           y_propio = puntoPropio[2]
           
           disX = x - x_propio
           disY = y - y_propio
           
           sumCuadrados = ((disX)**2) + ((disY)**2)
           
           return sumCuadrados**0.5 
           
           @action.add_function(".menorVida",(tuple, tuple, ))
        def _menorVida(vida, agentes):
            posMenor = 0
            for valor in len(vida):
                if vida[valor] < vida[posMenor]:
                    posMenor = valor 
                    
            return agentes[posMenor]
            
"---------------------------------------PATRULLERO2---------------------------------------"

class BDIPatrullero2(BDITroop):
      
      def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
        @actions.add_function(".patrulla1", (tuple,))
        def _patrulla1(puntoBandera):
            "
            Estos agentes patrullarán la zona más lejana a la bandera
            "            
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
        
        @actions.add_function(".patrulla2",(tuple,))           
        def _patrulla2(puntoBandera):
            "
            Estos agentes patrullarán la zona más cercana a la bandera
            "            
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
            
        @actions.add_function(".friendsAlive",0)
        def _friendsAlive():
            return self.team_count
            
        @actions.add_function(".medicsAlive",0)
        def _medicsAlive():
            return self.medics_count
            
        @actions.add_function(".opsAlive",0)
        def _opsAlive():
            return self.fieldops_count
            
        @actions.add_function(".soldiersAlive",0)
        def _medicsAlive():
            return self.soldiers_count
            
        @actions.add_function(".banderaRobada", 0)
        "
        En caso de ser robada la bandera, el soldado se va rápidamente a la base enemiga, ya que es muy probable que por el camino encuentre al enemigo que lleva la bandera
        "  
        def _banderaRobada():
            self.movement.destination.x = self.map.allied_base.get_init_x() - self.map.allied_base.get_end_x()
            self.movement.destination.z = self.map.allied_base.get_init_z() - self.map.allied_base.get_end_z()
            yield
            
        @actions.add_function(".disBandera", (tuple, tuple,))
        "
        Calcula la distancia a la que se encuentra de la bandera en ese instante.
        "
        def _disBandera(puntoBandera, puntoPropio):
           
           x_bandera = puntoBandera[0]
            y_bandera = puntoBandera[2]
            
           x_propio = puntoPropio[0]
           y_propio = puntoPropio[2]
           
           disX = x_bandera - x_propio
           disY = y_bandera - y_propio
           
           sumCuadrados = ((disX)**2) + ((disY)**2)
           
           return sumCuadrados**0.5 
            
        @actions.add_function(".disEnemigo", (tuple, tuple,))
        "
        Calcula la distancia a la que se encuentra del enemigo en ese intante.
        "
        def _disEnemigo(puntoEnemigo, puntoPropio):
           
            x_enemigo = puntoEnemigo[0]
            y_enemigo = puntoEnemigo[2]
            
           x_propio = puntoPropio[0]
           y_propio = puntoPropio[2]
           
           disX = x_enemigo - x_propio
           disY = y_enemigo - y_propio
           
           sumCuadrados = ((disX)**2) + ((disY)**2)
           
           return sumCuadrados**0.5 
           
        @actions.add_function(".disPunto", (tuple, tuple,))
        "
        Calcula la distancia a la que se encuentra del enemigo en ese intante.
        "
        def _disEnemigo(punto, puntoPropio):
           
            x = punto[0]
            y= punto[2]
            
           x_propio = puntoPropio[0]
           y_propio = puntoPropio[2]
           
           disX = x - x_propio
           disY = y - y_propio
           
           sumCuadrados = ((disX)**2) + ((disY)**2)
           
           return sumCuadrados**0.5             
            
            
"---------------------------------------MÉDICO1---------------------------------------"

class BDIenfermero1(BDIMedics):
    
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
    @actions.add_function(".movMed1",(tuple,))
    "
    El enfermero se moverá de manera aleatoria por el terreno que hay entre las dos filas de patrulleros, para así poder surtirles más fácilmente de suministros. Haremos lo mismo para el fieldOps. 
    "
    def _movMed1(puntoBandera):
        x_bandera = puntoBandera[0]
        y_bandera = puntoBandera[2]
        
        puntos = [y_bandera+30, y_bandera-30]
        
        while true:
            if(self.map.can_walk(x_bandera, puntos[0]):
                self.movement.destination.x = x_bandera
                self.movement.destination.z = puntos[0]
                wait(2000)
            if(self.map.can_walt(x_bandera, puntos[1]):
                self.movement.destination.x = x_bandera
                self.movement.destination.z = puntos[1]
                wait(2000)
        yield
            
            @actions.add_function(".aCubierto",(int,))
            "
            El médico, si ve que se ha muerto su compañero también médico, acude a la posición de la bandera para ponerse a salvo. 
            "
            def _aCubierto(puntoBandera):
                x = puntoBandera[0]
                y = puntoBandera[2]
                
                self.movement.destination_x = x
                self.movement.destination_z = y
                
                yield
                
                
"---------------------------------------MÉDICO2---------------------------------------"

class BDIenfermero2(BDIMedics):
    
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
        @actions.add_function(".movMed2",(tuple,))
         "
        El enfermero se moverá entre las dos filas de soldados para surtirles más facilmente.
        "
        def _movMed2(puntoBandera):
            x_bandera = puntoBandera[0]
            y_bandera = puntoBandera[2]
        
            puntos = [x_bandera+30, x_bandera-30]
        
            while true:
                if(self.map.can_walk(puntos[0], y_bandera):
                    self.movement.destination.x = puntos[0]
                    self.movement.destination.z = y_bandera
                    wait(2000)
                if(self.map.can_walt(puntos[1], y_bandera):
                    self.movement.destination.x = puntos[1]
                    self.movement.destination.z = y_bandera
                    wait(2000)
            yield

            
            @actions.add_function(".aCubierto",(int,))
            "
            El médico, si ve que se ha muerto su compañero también médico, acude a la posición de la bandera para ponerse a salvo. 
            "
            def _aCubierto(puntoBandera):
                x = puntoBandera[0]
                y = puntoBandera[2]
                
                self.movement.destination_x = x
                self.movement.destination_z = y
                
                yield
            
            
        
"---------------------------------------FIELD-OPS---------------------------------------"

class BDIoperacionesCampo(BDIFieldOps):
    
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
    @actions.add_function(".movFieldOps",(tuple,))
    "
    El FieldOps se moverá entre las dos zonas establecidas por los soldados.
    "
    def _movFieldOps(puntoBandera):
        x_bandera = puntoBandera[0]
        y_bandera = puntoBandera[2]
        
        puntos = [x_bandera+30, x_bandera-30, y_bandera+30, y_bandera-30]
        
        while true:
            if(self.map.can_walk(puntos[0], puntos[2]):
                self.movement.destination.x = puntos[0]
                self.movement.destination.z = puntos[2]
                wait(2000)
            if(self.map.can_walk(puntos[0], puntos[3]):
                self.movement.destination.x = puntos[0]
                self.movement.destination.z = puntos[3]
                wait(2000)
            if(self.map.can_walk(puntos[1], puntos[2]):
                self.movement.destination.x = puntos[1]
                self.movement.destination.z = puntos[2]
                wait(2000)
            if(self.map.can_walk(puntos[1], puntos[3]):
                self.movement.destination.x = puntos[1]
                self.movement.destination.z = puntos[3]
                wait(2000)
        yield
 
 
 "---------------------------------------CORONEL---------------------------------------"

class BDIcoronel(BDITroops):
    
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
    @actions.add_function(".movCoronel",(tuple,))
    "
    El FieldOps se moverá entre las dos zonas establecidas por los soldados.
    "
    def _movCoronel(puntoBandera):
        
        if(self.map.can_walk(puntoBandera[0], puntoBandera[2])):
            self.movement.destination.x = puntoBandera[0]
            self.movement.destination.z = puntoBandera[2]
    
        yield

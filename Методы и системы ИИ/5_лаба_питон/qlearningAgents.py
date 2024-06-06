# qlearningAgents.py
# ------------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


from game import *
from learningAgents import ReinforcementAgent
from featureExtractors import *

import random,util,math

class QLearningAgent(ReinforcementAgent):
    
    def __init__(self, **args):
        
        ReinforcementAgent.__init__(self, **args)
        self.QValue = util.Counter()

    def getQValue(self, state, action):
        
        
        return self.QValue[(state, action)]


    def computeValueFromQValues(self, state):
        
        best = float("-inf")

        actions = self.getLegalActions(state)
        for action in actions:
          if best < self.getQValue(state, action):
            best = self.getQValue(state, action)

        if best != float("-inf"):
          return best
        else:
          return 0.0

    def computeActionFromQValues(self, state):
       
        best = float("-inf")
        act = []

        actions = self.getLegalActions(state)
        if len(actions) == 0:
          return None

        for action in actions:
          if best < self.getQValue(state, action):
            best = self.getQValue(state, action)
            act = [action]
          elif best == self.getQValue(state, action):
            act.append(action)
        
        return random.choice(act)

    def getAction(self, state):
        
        legalActions = self.getLegalActions(state)
        
        if util.flipCoin(self.epsilon):
            return random.choice(legalActions)
        else:
            return self.computeActionFromQValues(state)

    def update(self, state, action, nextState, reward):
        
        self.QValue[(state, action)] = (1-self.alpha)*self.QValue[(state, action)] + self.alpha*(reward + self.discount*self.computeValueFromQValues(nextState))
        

    def getPolicy(self, state):
        return self.computeActionFromQValues(state)

    def getValue(self, state):
        return self.computeValueFromQValues(state)


class PacmanQAgent(QLearningAgent):
    

    def __init__(self, epsilon=0.05,gamma=0.8,alpha=0.2, numTraining=0, **args):
        
        args['epsilon'] = epsilon
        args['gamma'] = gamma
        args['alpha'] = alpha
        args['numTraining'] = numTraining
        self.index = 0  
        QLearningAgent.__init__(self, **args)

    def getAction(self, state):
        
        action = QLearningAgent.getAction(self,state)
        self.doAction(state,action)
        return action


class ApproximateQAgent(PacmanQAgent):
    
    def __init__(self, extractor='IdentityExtractor', **args):
        self.featExtractor = util.lookup(extractor, globals())()
        PacmanQAgent.__init__(self, **args)
        self.weights = util.Counter()

    def getWeights(self):
        return self.weights

    def getQValue(self, state, action):
        
        weights = self.getWeights()
        features = self.featExtractor.getFeatures(state, action)
        q = weights * features
        return q

    def update(self, state, action, nextState, reward):
        
        weights = self.getWeights()
        features = self.featExtractor.getFeatures(state, action)
        
        nextActions = self.getLegalActions(nextState)
        maxNextQ = float("-inf")
        
        for act in nextActions:
            q = self.getQValue(nextState, act)
            maxNextQ = max(maxNextQ, q)

        if len(nextActions) == 0:
            maxNextQ = 0.0

        difference = reward + self.discount*maxNextQ - self.getQValue(state, action)
        for feature in features:
            weights[feature] = weights[feature] + self.alpha * difference * features[feature]

    def final(self, state):
        PacmanQAgent.final(self, state)

        if self.episodesSoFar == self.numTraining:
            
            pass


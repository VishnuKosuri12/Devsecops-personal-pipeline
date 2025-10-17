import React from 'react';
import { Trophy, User, Users, LucideIcon } from 'lucide-react';

// Sub-component to handle a single score row
interface ScoreRowProps {
  label: string;
  score: number;
  icon: LucideIcon;
  color: 'indigo' | 'purple' | 'gray';
}

const ScoreRow: React.FC<ScoreRowProps> = ({ label, score, icon: Icon, color }) => {
  const bgColor = `bg-${color}-50`;
  const textColor = `text-${color}-600`;

  return (
    <div className={`flex justify-between items-center p-2 rounded ${bgColor}`}>
      <div className="flex items-center gap-2">
        <Icon className={`h-4 w-4 ${textColor}`} />
        <span className="font-medium">{label}</span>
      </div>
      <span className={`text-lg font-bold ${textColor}`}>{score}</span>
    </div>
  );
};

interface ScoreBoardProps {
  scores: {
    X: number;
    O: number;
    draws: number;
  };
}

const ScoreBoard: React.FC<ScoreBoardProps> = ({ scores }) => {
  return (
    <div 
      className="bg-white p-4 rounded-xl shadow-lg border border-gray-100"
      aria-labelledby="scoreboard-heading"
    >
      <h2 id="scoreboard-heading" className="text-xl font-extrabold text-gray-900 mb-4 flex items-center gap-2">
        <Trophy className="h-6 w-6 text-yellow-500" />
        Game Scoreboard
      </h2>
      
      <div className="space-y-3">
        <ScoreRow label="Pushpa Raj (X)" score={scores.X} icon={User} color="indigo" />
        <ScoreRow label="Appanna (O)" score={scores.O} icon={User} color="purple" />
        <ScoreRow label="Draws" score={scores.draws} icon={Users} color="gray" />
      </div>
    </div>
  );
};

export default ScoreBoard;

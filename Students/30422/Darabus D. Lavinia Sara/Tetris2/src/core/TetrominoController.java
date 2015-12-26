package core;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JOptionPane;

import ui.TetrisFrame;

public class TetrominoController implements GameObserver{
	
	private TetrisFrame tetrisFrame;

	public void runTetrisGame() {
		// TODO Auto-generated method stub
		tetrisFrame = new TetrisFrame();
		tetrisFrame.addKeyListener(new TetrisKeyListener());
	}
	
	private class TetrisKeyListener implements KeyListener{

		private static final String ROTATE = "ROTATE";
		private static final String LEFT = "LEFT";
		private static final String RIGHT = "RIGHT";
		private static final String DOWN = "DOWN";

		@Override
		public void keyPressed(KeyEvent e) {
			// TODO Auto-generated method stub
			
			int keyCode = e.getKeyCode();
			
			switch(keyCode){
			case KeyEvent.VK_UP:
				tetrisFrame.moveTetromino(ROTATE);
				break;
			case KeyEvent.VK_LEFT:
				tetrisFrame.moveTetromino(LEFT);
				break;
			case KeyEvent.VK_RIGHT:
				tetrisFrame.moveTetromino(RIGHT);
				break;
			case KeyEvent.VK_DOWN:
				tetrisFrame.moveTetromino(DOWN);
				break;
			case KeyEvent.VK_R:
				resetGame();
				break;
			}
		}
		
		private void resetGame(){
			tetrisFrame.setVisible(false);
			tetrisFrame.dispose();
			runTetrisGame();
		}

		@Override
		public void keyReleased(KeyEvent arg0) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void keyTyped(KeyEvent arg0) {
			// TODO Auto-generated method stub
			
		}
		
	}

	@Override
	public void notifyLoss() {
		// TODO Auto-generated method stub
		JOptionPane.showMessageDialog(null, "You lost!");//when board is filled with pieces
		System.exit(0);
	}

	@Override
	public void notifyWin() {
		// TODO Auto-generated method stub
		JOptionPane.showMessageDialog(null, "You won!");//after clearing 15 lines
		System.exit(0);
	}

}

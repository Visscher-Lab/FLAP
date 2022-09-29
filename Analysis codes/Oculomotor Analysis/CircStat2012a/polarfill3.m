function polarfill4(ax_polar,theta,rlow,rhigh,color,alpha)
    ax_cart = axes();
  %  ax_polar.ThetaLim = [-180 180];
    ax_polar.ThetaZeroLocation = 'top';
    ax_polar.ThetaDir = 'clockwise';
    %ax_polar.ThetaTick = -180:45:180;
    ax_cart.Position = ax_polar.Position;
    [xl,yl] = pol2cart(theta,rlow);
    [xh,yh] = pol2cart((theta),(rhigh));
    fill([xl,xh],[yl,yh],color,'FaceAlpha',alpha,'EdgeAlpha',0);
  %  xlim(ax_cart,[-max(get(ax_polar,'RLim')),max(get(ax_polar,'RLim'))]); 
  %  ylim(ax_cart,[-max(get(ax_polar,'RLim')),max(get(ax_polar,'RLim'))]);
   % ylim(ax_cart,[0, 30]);
    %    xlim(ax_cart,[0, 30]);
    axis square; set(ax_cart,'visible','off');
    xlim(ax_cart, [-60, 60]);
        ylim(ax_cart, [-60, 60]);

    
end

